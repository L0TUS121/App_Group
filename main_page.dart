import 'package:flutter/material.dart';

import 'home_page.dart';
import 'schedule_page.dart';
import 'subjects_page.dart';
import '../widgets/service_tile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [HomePage(), SchedulePage(), SubjectsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          // Натиснули "Інше"
          if (index == 3) {
            showServicesSheet(context);
            return;
          }

          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Головна',
          ),

          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Розклад',
          ),

          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Предмети',
          ),

          NavigationDestination(icon: Icon(Icons.apps_outlined), label: 'Інше'),
        ],
      ),
    );
  }
}

void showServicesSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,

    // Красиві заокруглені краї
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),

    showDragHandle: true,

    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Інші сервіси',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18),

            ServiceTile(
              icon: Icons.school_outlined,
              title: 'Moodle',
              subtitle: 'Навчальна платформа',
              onTap: () {
                // Пізніше відкриємо Moodle
              },
            ),

            ServiceTile(
              icon: Icons.menu_book_outlined,
              title: 'Електронний щоденник',
              subtitle: 'Оцінки та навчання',
              onTap: () {
                // Пізніше відкриємо щоденник
              },
            ),

            ServiceTile(
              icon: Icons.cloud_outlined,
              title: 'Google Drive',
              subtitle: 'Файли групи',
              onTap: () {},
            ),
          ],
        ),
      );
    },
  );
}
