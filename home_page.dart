import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/lesson.dart';
import '../models/subject.dart';
import '../services/firestore_service.dart';
import '../widgets/announcements_block.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/page_header.dart';
import '../widgets/quick_action.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          //верхня панель
          const PageHeader(title: 'Головна'),

          const SizedBox(height: 28),

          //дата
          const CurrentDateTime(),

          const SizedBox(height: 30),

          const Text(
            'СЬОГОДНІ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const TodaySchedule(),
          const SizedBox(height: 28),
          // Швидкі дії
          Row(
            children: [
              Expanded(
                child: QuickAction(
                  icon: Icons.school_outlined,
                  text: 'Moodle',
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: QuickAction(
                  icon: Icons.menu_book_outlined,
                  text: 'Щоденник',
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          const Text(
            'СПОВІЩЕННЯ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          const AnnouncementsBlock(),
        ],
      ),
    );
  }
}

//годинник
class CurrentDateTime extends StatefulWidget {
  const CurrentDateTime({super.key});

  @override
  State<CurrentDateTime> createState() => _CurrentDateTimeState();
}

class _CurrentDateTimeState extends State<CurrentDateTime> {
  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(_now);
    final date = DateFormat('EEEE, d MMMM', 'uk_UA').format(_now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        Text(date, style: const TextStyle(fontSize: 17, color: Colors.grey)),
      ],
    );
  }
}

// Список пар на сьогодні.
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

                subject: getSubjectName(lessons[i].subjectId),

                time: '${lessons[i].startTime} – ${lessons[i].endTime}',

                room: lessons[i].room,
              ),
          ],
        );
      },
    );
  }
}
