import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // FCM topics

  static const announcementsTopic = 'group_announcements';

  static const scheduleTopic = 'group_schedule';

  static const homeworkTopic = 'group_homework';

  // Android notification channel

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'clamorix_notifications',
    'Clamorix',
    description: 'Сповіщення Clamorix',
    importance: Importance.high,
  );

  // ==========================================
  // Запуск системи сповіщень
  // ==========================================

  Future<void> initialize() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Local notifications

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _local.initialize(settings: settings);

    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);

    // Відновлюємо підписки

    await _restoreTopics();

    // Push коли програма відкрита

    FirebaseMessaging.onMessage.listen((message) async {
      final notification = message.notification;

      if (notification == null) {
        return;
      }

      await _local.show(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),

        title: notification.title ?? 'Clamorix',

        body: notification.body ?? '',

        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,

            channelDescription: _channel.description,

            importance: Importance.high,

            priority: Priority.high,
          ),
        ),
      );
    });
  }

  // ==========================================
  // Відновлення після запуску програми
  // ==========================================

  Future<void> _restoreTopics() async {
    await _updateTopic(announcementsTopic, await getAnnouncementsEnabled());

    await _updateTopic(scheduleTopic, await getScheduleEnabled());

    await _updateTopic(homeworkTopic, await getHomeworkEnabled());
  }

  // ==========================================
  // Загальна логіка
  // ==========================================

  Future<void> _updateTopic(String topic, bool enabled) async {
    if (enabled) {
      await _messaging.subscribeToTopic(topic);
    } else {
      await _messaging.unsubscribeFromTopic(topic);
    }
  }

  Future<void> _saveTopic({
    required String topic,
    required String key,
    required bool enabled,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, enabled);

    await _updateTopic(topic, enabled);
  }

  Future<bool> _readSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key) ?? true;
  }

  // ==========================================
  // Оголошення
  // ==========================================

  Future<bool> getAnnouncementsEnabled() =>
      _readSetting('announcements_enabled');

  Future<void> setAnnouncementsEnabled(bool value) => _saveTopic(
    topic: announcementsTopic,
    key: 'announcements_enabled',
    enabled: value,
  );

  // ==========================================
  // Розклад
  // ==========================================

  Future<bool> getScheduleEnabled() => _readSetting('schedule_enabled');

  Future<void> setScheduleEnabled(bool value) =>
      _saveTopic(topic: scheduleTopic, key: 'schedule_enabled', enabled: value);

  // ==========================================
  // Домашні завдання
  // ==========================================

  Future<bool> getHomeworkEnabled() => _readSetting('homework_enabled');

  Future<void> setHomeworkEnabled(bool value) =>
      _saveTopic(topic: homeworkTopic, key: 'homework_enabled', enabled: value);
}
