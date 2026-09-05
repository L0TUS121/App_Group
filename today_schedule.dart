import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../models/lesson.dart';
import '../services/firestore_service.dart';

class TodaySchedule extends StatelessWidget {
  const TodaySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return StreamBuilder<List<Lesson>>(
      stream: FirestoreService.instance.lessonsForDate(today),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Не вдалося завантажити розклад');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final lessons = snapshot.data!;

        if (lessons.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,

              borderRadius: BorderRadius.circular(20),
            ),

            child: const Row(
              children: [
                Icon(Icons.event_available),

                SizedBox(width: 12),

                Text('Сьогодні занять немає 🎉'),
              ],
            ),
          );
        }

        return Column(
          children: [
            for (int i = 0; i < lessons.length; i++)
              LessonTile(
                number: '${i + 1}',
                subject: lessons[i].subjectId,
                time: '${lessons[i].startTime} – ${lessons[i].endTime}',
                room: lessons[i].room,
              ),
          ],
        );
      },
    );
  }
}

class LessonTile extends StatelessWidget {
  const LessonTile({
    required this.number,
    required this.subject,
    required this.time,
    required this.room,
    super.key,
  });

  final String number;
  final String subject;
  final String time;
  final String room;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(number)),
        title: Text(subject),
        subtitle: Text('$time • Кабінет $room'),
      ),
    );
  }
}
