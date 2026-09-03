# Clamorix

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('uk_UA');
  runApp(const GroupApp());
}

class GroupApp extends StatelessWidget {
  const GroupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Наша група',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),

      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class CurrentDateTime extends StatefulWidget {
  const CurrentDateTime({super.key});

  @override
  State<CurrentDateTime> createState() => _CurrentDateTimeState();
}

//годинник
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

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ServiceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Material(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),

        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.all(15),

            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,

                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: Icon(icon, color: Colors.white),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

@override
Widget build(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: 'Головна'),

            const SizedBox(height: 28),
          ],
        ),
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

// ГОЛОВНА

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

          SizedBox(height: 30),

          Text(
            'СЬОГОДНІ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          LessonTile(
            number: '1',
            subject: 'Спеціальні розділи математики',
            time: '08:30 – 9:50',
            room: '305',
          ),

          LessonTile(
            number: '2',
            subject: 'Програмування',
            time: '10:05 – 11:25',
            room: '207',
          ),

          LessonTile(
            number: '3',
            subject: 'Англійська мова',
            time: '11:40 – 13:00',
            room: '105',
          ),

          LessonTile(
            number: '4',
            subject: 'Фізика',
            time: '14:40 – 16:00',
            room: '304',
          ),

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

          SizedBox(height: 28),

          Text(
            'СПОВІЩЕННЯ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.notifications_outlined, color: Colors.white),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Завтра першу пару скасовано',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LessonTile extends StatelessWidget {
  final String number;
  final String subject;
  final String time;
  final String room;

  const LessonTile({
    super.key,
    required this.number,
    required this.subject,
    required this.time,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '$time  •  ауд. $room',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// РОЗКЛАД
class Lesson {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final String subjectId;
  final String room;
  final String type;

  const Lesson({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.subjectId,
    required this.room,
    required this.type,
  });

  factory Lesson.fromFirestore(String id, Map<String, dynamic> data) {
    return Lesson(
      id: id,
      date: data['date'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      subjectId: data['subjectId'] ?? '',
      room: data['room'] ?? '',
      type: data['type'] ?? '',
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

String _lessonTypeName(String type) {
  switch (type.toLowerCase()) {
    case 'lecture':
      return 'Лекція';

    case 'practice':
      return 'Практична';

    case 'lab':
      return 'Лабораторна';

    default:
      return type;
  }
}

String getSubjectName(String subjectId) {
  switch (subjectId.toLowerCase()) {
    case 'srm':
      return 'СРМ';
    case 'tek':
      return 'ТЕК';
    case 'fv':
      return 'ФВ';
    case 'at':
      return 'АТ';
    case 'kpp':
      return 'КПП';
    case 'am':
      return 'АМ';
    case 'fil':
      return 'ФІЛ';
    case 'zt':
      return 'ЗТ';
    case 'ovu':
      return 'ОВУ';
    case 'ovzv':
      return 'ОВЗв';
    case 'szvp':
      return 'СЗВП';
    case 'ovzak':
      return 'ОВЗак';
    case 'rp':
      return 'РП';
    case 'ikg':
      return 'ІКГ';
    case '-':
      return 'Сампо';

    default:
      return subjectId;
  }
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

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('lessons')
                      .where(
                        'date',
                        isEqualTo: DateFormat('yyyy-MM-dd')
                            .format(selectedDate),
                      )
                      .snapshots(),
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

                    final lessons = snapshot.data!.docs.map((doc) {
                      return Lesson.fromFirestore(
                        doc.id,
                        doc.data() as Map<String, dynamic>,
                      );
                    }).toList();
                    // Оскільки HH:mm має формат 08:30, 10:05 тощо,
                    // рядкове сортування тут працюватиме правильно.
                    lessons.sort((a, b) => a.startTime.compareTo(b.startTime));
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
                          subject: getSubjectName(lesson.subjectId),
                          details:
                              '${_lessonTypeName(lesson.type)} · ауд. ${lesson.room}',
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

class ScheduleLesson extends StatelessWidget {
  final String start;
  final String end;
  final String subject;
  final String details;

  const ScheduleLesson({
    super.key,
    required this.start,
    required this.end,
    required this.subject,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  start,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  end,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(details, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ПРЕДМЕТИ
class Subject {
  final String shortName;
  final String fullName;

  final String lectureTeacher;
  final String lecturePhone;

  final String practiceTeacher;
  final String practicePhone;

  final String homework;

  const Subject({
    required this.shortName,
    required this.fullName,
    required this.lectureTeacher,
    required this.lecturePhone,
    required this.practiceTeacher,
    required this.practicePhone,
    required this.homework,
  });
}

const List<Subject> subjects = [
  Subject(
    shortName: 'СРМ',
    fullName: 'Спеціальні розділи математики',
    lectureTeacher: 'Викладач вищої математики',
    lecturePhone: '—',
    practiceTeacher: 'Викладач вищої математики',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'КПП',
    fullName: 'Крос-платформне програмування',
    lectureTeacher: 'Викладач програмування',
    lecturePhone: '—',
    practiceTeacher: 'Викладач програмування',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'АМ',
    fullName: 'Англійська мова',
    lectureTeacher: 'Викладач англійської мови',
    lecturePhone: '—',
    practiceTeacher: 'Викладач англійської мови',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ТЕК',
    fullName: 'Теорія електронних кіл',
    lectureTeacher: 'Викладач фізики',
    lecturePhone: '—',
    practiceTeacher: 'Викладач фізики',
    practicePhone: '—',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ФІЛ',
    fullName: 'Філософія',
    lectureTeacher: 'Викладач філософії',
    lecturePhone: '-',
    practiceTeacher: 'Викладач філософії',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ЗТ',
    fullName: 'Загальна тактика',
    lectureTeacher: 'Викладач тактики',
    lecturePhone: '-',
    practiceTeacher: 'Викладач тактики',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ОВУ',
    fullName: 'Основи військового управління',
    lectureTeacher: 'Викладач ОВУ',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ОВУ',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ОВЗв',
    fullName: 'Організація військового зв\'язку',
    lectureTeacher: 'Викладач ОВЗв',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ОВЗв',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'СЗВП',
    fullName: 'Стрілецька зброя та вогнева підготовка',
    lectureTeacher: 'Викладач СЗВП',
    lecturePhone: '-',
    practiceTeacher: 'Викладач СЗВП',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ОВЗак',
    fullName: 'Основи військового законодавства та МГП',
    lectureTeacher: 'Викладач ОВЗак',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ОВЗак',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'РП',
    fullName: 'Розвідувальна підготовка',
    lectureTeacher: 'Викладач розвідки',
    lecturePhone: '-',
    practiceTeacher: 'Викладач розвідки',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'АТ',
    fullName: 'Автомобільна техніка',
    lectureTeacher: 'Викладач техніки',
    lecturePhone: '-',
    practiceTeacher: 'Викладач техніки',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ФВ',
    fullName: 'Фізичне виховання',
    lectureTeacher: 'Викладач фізо',
    lecturePhone: '-',
    practiceTeacher: 'Викладач фізо',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
  Subject(
    shortName: 'ІКГ',
    fullName: 'Інженерна та комп\'ютерна графіка',
    lectureTeacher: 'Викладач ІКГ',
    lecturePhone: '-',
    practiceTeacher: 'Викладач ІКГ',
    practicePhone: '-',
    homework: 'Домашнє завдання не задано',
  ),
];

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = subjects.where((subject) {
      final query = searchQuery.toLowerCase();

      return subject.shortName.toLowerCase().contains(query) ||
          subject.fullName.toLowerCase().contains(query) ||
          subject.lectureTeacher.toLowerCase().contains(query) ||
          subject.practiceTeacher.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(title: 'Предмети'),

                const SizedBox(height: 18),

                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Пошук предмету...',
                    prefixIcon: const Icon(Icons.search),

                    filled: true,
                    fillColor: Colors.grey.shade100,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  '${filteredSubjects.length} предметів',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),

              itemCount: filteredSubjects.length,

              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },

              itemBuilder: (context, index) {
                final subject = filteredSubjects[index];

                return SubjectCard(
                  subject: subject,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SubjectDetailsPage(subject: subject);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectsPages extends StatefulWidget {
  const SubjectsPages({super.key});

  @override
  State<SubjectsPages> createState() => _SubjectsPagesState();
}

class _SubjectsPagesState extends State<SubjectsPages> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = subjects.where((subject) {
      final query = searchQuery.toLowerCase();

      return subject.shortName.toLowerCase().contains(query) ||
          subject.fullName.toLowerCase().contains(query) ||
          subject.lectureTeacher.toLowerCase().contains(query) ||
          subject.practiceTeacher.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(title: 'Предмети'),

                const SizedBox(height: 18),

                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Пошук предмету...',
                    prefixIcon: const Icon(Icons.search),

                    filled: true,
                    fillColor: Colors.grey.shade100,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  '${filteredSubjects.length} предметів',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),

              itemCount: filteredSubjects.length,

              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },

              itemBuilder: (context, index) {
                final subject = filteredSubjects[index];

                return SubjectCard(
                  subject: subject,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SubjectDetailsPage(subject: subject);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectCard({super.key, required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Text(
                  subject.shortName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      subject.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Лекції: ${subject.lectureTeacher}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    Text(
                      'Практичні: ${subject.practiceTeacher}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectDetailsPage extends StatelessWidget {
  final Subject subject;

  const SubjectDetailsPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subject.shortName)),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Text(
            subject.fullName,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          const Text(
            'ВИКЛАДАЧІ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          TeacherTile(
            type: 'Лекції',
            name: subject.lectureTeacher,
            phone: subject.lecturePhone,
          ),

          const SizedBox(height: 10),

          TeacherTile(
            type: 'Практичні',
            name: subject.practiceTeacher,
            phone: subject.practicePhone,
          ),

          const SizedBox(height: 30),

          const Text(
            'НА НАСТУПНУ ПАРУ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              subject.homework,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

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
        color: Colors.grey.shade100,
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
          color: Colors.grey.shade100,
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

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),

      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon),
      ),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

      subtitle: Text(subtitle),

      trailing: Switch(value: value, onChanged: onChanged),
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
