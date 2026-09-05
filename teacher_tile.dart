import 'package:flutter/material.dart';

class TeacherTile extends StatelessWidget {
  final String type;
  final String name;
  final String phone;

  const TeacherTile({
    super.key,
    required this.type,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Icon(Icons.person_outline),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  type,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 2),

                Text(phone, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
