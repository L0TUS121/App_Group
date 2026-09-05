import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // =====================================================
  // FCM TOPICS
  // =====================================================

  static const String announcementsTopic = 'group_announcements';

  static const String scheduleTopic = 'group_schedule';

  static const String homeworkTopic = 'group_homework';

  // =====================================================
  // LOCAL NOTIFICATION CHANNEL
  // =====================================================

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'clamorix_notifications',
    'Clamorix',
    description: 'Сповіщення Clamorix',
    importance: Importance.high,
  );

  // =====================================================
  // INITIALIZE
  // =====================================================

  Future<void> initialize() async {
    // Дозвіл Android/iOS
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // ---------------------------------
    // Local Notifications
    // ---------------------------------

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings: initializationSettings);

    // Android notification channel

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);

    // ---------------------------------
    // Відновлюємо налаштування
    // ---------------------------------

    final announcementsEnabled = await getAnnouncementsEnabled();

    final scheduleEnabled = await getScheduleEnabled();

    final homeworkEnabled = await getHomeworkEnabled();

    await _updateTopic(announcementsTopic, announcementsEnabled);

    await _updateTopic(scheduleTopic, scheduleEnabled);

    await _updateTopic(homeworkTopic, homeworkEnabled);

    // ---------------------------------
    // FCM коли застосунок ВІДКРИТИЙ
    // ---------------------------------

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;

      if (notification == null) {
        return;
      }

      await _localNotifications.show(
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

            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });
  }

  // =====================================================
  // TOPIC
  // =====================================================

  Future<void> _updateTopic(String topic, bool enabled) async {
    if (enabled) {
      await _messaging.subscribeToTopic(topic);
    } else {
      await _messaging.unsubscribeFromTopic(topic);
    }
  }

  // =====================================================
  // SAVE SETTING
  // =====================================================

  Future<void> _setTopicEnabled({
    required String topic,
    required String key,
    required bool enabled,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, enabled);

    await _updateTopic(topic, enabled);
  }

  // =====================================================
  // READ SETTING
  // =====================================================

  Future<bool> _getSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key) ?? true;
  }

  // =====================================================
  // ANNOUNCEMENTS
  // =====================================================

  Future<void> setAnnouncementsEnabled(bool enabled) {
    return _setTopicEnabled(
      topic: announcementsTopic,

      key: 'announcements_enabled',

      enabled: enabled,
    );
  }

  Future<bool> getAnnouncementsEnabled() {
    return _getSetting('announcements_enabled');
  }

  // =====================================================
  // SCHEDULE
  // =====================================================

  Future<void> setScheduleEnabled(bool enabled) {
    return _setTopicEnabled(
      topic: scheduleTopic,

      key: 'schedule_enabled',

      enabled: enabled,
    );
  }

  Future<bool> getScheduleEnabled() {
    return _getSetting('schedule_enabled');
  }

  // =====================================================
  // HOMEWORK
  // =====================================================

  Future<void> setHomeworkEnabled(bool enabled) {
    return _setTopicEnabled(
      topic: homeworkTopic,

      key: 'homework_enabled',

      enabled: enabled,
    );
  }

  Future<bool> getHomeworkEnabled() {
    return _getSetting('homework_enabled');
  }
}
