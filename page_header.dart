import 'package:flutter/material.dart';

import '../screens/settings_page.dart';

class PageHeader extends StatelessWidget {
  final String title;

  const PageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        IconButton.filledTonal(
          icon: const Icon(Icons.settings_outlined),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }
}
