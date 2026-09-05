import 'package:flutter/material.dart';

import '../models/announcement.dart';
import '../services/firestore_service.dart';

class AnnouncementsBlock extends StatelessWidget {
  const AnnouncementsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Announcement>>(
      stream: FirestoreService.instance.announcements(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Не вдалося завантажити сповіщення');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final announcements = snapshot.data!;

        if (announcements.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Нових повідомлень немає'),
          );
        }

        // Найновіші зверху (сортування вже виконано у FirestoreService).
        final announcement = announcements.first;

        return Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).colorScheme.onSecondary,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      announcement.title,

                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      announcement.message,

                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
