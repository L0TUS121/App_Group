import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),

      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon),
      ),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

      subtitle: Text(subtitle),

      trailing: const Icon(Icons.chevron_right, color: Colors.grey),

      onTap: onTap,
    );
  }
}
