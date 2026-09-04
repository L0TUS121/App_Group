import 'package:flutter/material.dart';

import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

// НАЛАШТУВАННЯ

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool scheduleNotifications = true;
  bool homeworkNotifications = true;
  bool showPastLessons = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування')),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

        children: [
          const SettingsSectionTitle(title: 'ВИГЛЯД'),

          SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Тема',
            subtitle: 'Системна',
            onTap: () {
              // Зробимо трохи пізніше
            },
          ),

          const SizedBox(height: 28),

          const SettingsSectionTitle(title: 'СПОВІЩЕННЯ'),

          SettingsSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Зміни розкладу',
            subtitle: 'Сповіщати про перенесення та скасування',
            value: scheduleNotifications,
            onChanged: (value) {
              setState(() {
                scheduleNotifications = value;
              });
            },
          ),

          SettingsSwitchTile(
            icon: Icons.assignment_outlined,
            title: 'Домашні завдання',
            subtitle: 'Нагадувати про домашні завдання',
            value: homeworkNotifications,
            onChanged: (value) {
              setState(() {
                homeworkNotifications = value;
              });
            },
          ),

          const SizedBox(height: 28),

          const SettingsSectionTitle(title: 'РОЗКЛАД'),

          SettingsSwitchTile(
            icon: Icons.history,
            title: 'Минулі пари',
            subtitle: 'Показувати завершені пари',
            value: showPastLessons,
            onChanged: (value) {
              setState(() {
                showPastLessons = value;
              });
            },
          ),

          const SizedBox(height: 28),

          const SettingsSectionTitle(title: 'ПРО ЗАСТОСУНОК'),

          SettingsTile(
            icon: Icons.info_outline,
            title: 'Про Clamorix',
            subtitle: 'Версія 0.1.0 Beta',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Clamorix',
                applicationVersion: '0.1.0 Beta',
                applicationLegalese: 'Навчальний застосунок групи',
              );
            },
          ),

          SettingsTile(
            icon: Icons.system_update_outlined,
            title: 'Перевірити оновлення',
            subtitle: 'Встановлено актуальну версію',
            onTap: () {},
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
