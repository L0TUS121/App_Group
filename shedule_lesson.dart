import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/lesson.dart';
import '../services/firestore_service.dart';
import '../widgets/page_header.dart';
import '../widgets/schedule_lesson.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late DateTime selectedDate;
  late DateTime currentWeekStart;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    currentWeekStart = _startOfWeek(selectedDate);
  }

  DateTime _startOfWeek(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> get weekDays {
    return List.generate(
      7,
      (index) => currentWeekStart.add(Duration(days: index)),
    );
  }

  void previousWeek() {
    setState(() {
      currentWeekStart = currentWeekStart.subtract(const Duration(days: 7));

      selectedDate = currentWeekStart;
    });
  }

  void nextWeek() {
    setState(() {
      currentWeekStart = currentWeekStart.add(const Duration(days: 7));

      selectedDate = currentWeekStart;
    });
  }

  void goToToday() {
    setState(() {
      selectedDate = DateTime.now();
      currentWeekStart = _startOfWeek(selectedDate);
    });
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final days = weekDays;

    final selectedDateText = DateFormat(
      'EEEE, d MMMM',
      'uk_UA',
    ).format(selectedDate);

    final monthText = DateFormat('LLLL yyyy', 'uk_UA').format(selectedDate);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Column(
              children: [
                const PageHeader(title: 'Розклад'),

                const SizedBox(height: 18),

                Row(
                  children: [
                    IconButton(
                      onPressed: previousWeek,
                      icon: const Icon(Icons.chevron_left),
                    ),

                    Expanded(
                      child: Center(
                        child: Text(
                          monthText,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: goToToday,
                      child: const Text('Сьогодні'),
                    ),

                    IconButton(
                      onPressed: nextWeek,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 78,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              scrollDirection: Axis.horizontal,

              itemCount: days.length,

              separatorBuilder: (_, _) => const SizedBox(width: 8),

              itemBuilder: (context, index) {
                final day = days[index];

                final selected = isSameDay(day, selectedDate);

                final today = isSameDay(day, DateTime.now());

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = day;
                    });
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),

                    width: 52,

                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainer,

                      borderRadius: BorderRadius.circular(18),

                      border: today && !selected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          DateFormat('E', 'uk_UA').format(day).toUpperCase(),

                          style: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '${day.day}',

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,

                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),

              children: [
                Text(
                  _capitalize(selectedDateText),

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                StreamBuilder<List<Lesson>>(
                  stream: FirestoreService.instance.lessonsForDate(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Помилка завантаження:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final lessons = snapshot.data!;

                    if (lessons.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 42,
                                color: Colors.grey,
                              ),

                              SizedBox(height: 12),

                              Text(
                                'На цей день занять немає',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: lessons.map((lesson) {
                        return ScheduleLesson(
                          start: lesson.startTime,
                          end: lesson.endTime,
                          subject: lesson.subjectId,
                          details:
                              '${lessonTypeName(lesson.type)} · ауд. ${lesson.room}',
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _capitalize(String text) {
  if (text.isEmpty) return text;

  return text[0].toUpperCase() + text.substring(1);
}
