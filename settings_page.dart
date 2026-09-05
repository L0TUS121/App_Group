import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';
import '../services/theme_service.dart';
import '../services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool announcements = true;
  bool schedule = true;
  bool homework = true;

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notifications = NotificationService.instance;

    final a = await notifications.getAnnouncementsEnabled();
    final s = await notifications.getScheduleEnabled();
    final h = await notifications.getHomeworkEnabled();

    if (!mounted) return;

    setState(() {
      announcements = a;
      schedule = s;
      homework = h;

      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування')),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

              children: [
                const SettingsSectionTitle(title: 'ТЕМА'),

                //Теми
                SettingsSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Темна тема',
                  subtitle: 'Використовувати темну тему застосунку',
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) async {
                    await ThemeService.instance.setTheme(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),

                const SettingsSectionTitle(title: 'СПОВІЩЕННЯ'),

                // Оголошення
                SettingsSwitchTile(
                  icon: Icons.campaign_outlined,
                  title: 'Оголошення',
                  subtitle: 'Важливі повідомлення групи',
                  value: announcements,
                  onChanged: (value) async {
                    await NotificationService.instance.setAnnouncementsEnabled(
                      value,
                    );

                    if (!mounted) return;

                    setState(() {
                      announcements = value;
                    });
                  },
                ),

                // Розклад
                SettingsSwitchTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Зміни розкладу',
                  subtitle: 'Перенесення та скасування пар',
                  value: schedule,
                  onChanged: (value) async {
                    await NotificationService.instance.setScheduleEnabled(
                      value,
                    );

                    if (!mounted) return;

                    setState(() {
                      schedule = value;
                    });
                  },
                ),

                // Домашні завдання
                SettingsSwitchTile(
                  icon: Icons.assignment_outlined,
                  title: 'Домашні завдання',
                  subtitle: 'Нові домашні завдання',
                  value: homework,
                  onChanged: (value) async {
                    await NotificationService.instance.setHomeworkEnabled(
                      value,
                    );

                    if (!mounted) return;

                    setState(() {
                      homework = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                const SettingsSectionTitle(title: 'АКАУНТ'),

                SettingsTile(
                  icon: Icons.logout,
                  title: 'Вийти з акаунту',
                  subtitle: 'Повернутися на сторінку входу',

                  onTap: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,

                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Вийти з акаунту?'),

                          content: const Text(
                            'Для повторного входу потрібно буде '
                            'ввести електронну пошту та пароль.',
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Скасувати'),
                            ),

                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Вийти'),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldLogout != true) {
                      return;
                    }

                    await AuthService.instance.signOut();

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),

                const SizedBox(height: 30),

                const SettingsSectionTitle(title: 'ПРО ЗАСТОСУНОК'),

                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'Про Clamorix',
                  subtitle: 'Версія 0.1.1 Beta',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Clamorix',
                      applicationVersion: '0.1.1 Beta',
                      applicationLegalese: 'Навчальний застосунок групи',
                    );
                  },
                ),
              ],
            ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  final String title;

  const SettingsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}
