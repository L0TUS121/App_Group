import 'package:flutter/material.dart';

import '../models/assignment.dart';
import '../models/subject.dart';
import '../services/firestore_service.dart';
import '../widgets/teacher_tile.dart';

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
          // Повна назва предмету
          Text(
            subject.fullName,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          // -------------------------
          // ВИКЛАДАЧІ
          // -------------------------
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

          // -------------------------
          // ДОМАШНЄ ЗАВДАННЯ
          // -------------------------
          const Text(
            'НА НАСТУПНУ ПАРУ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          StreamBuilder<List<Assignment>>(
            stream: FirestoreService.instance.assignmentsForSubject(subject.id),

            builder: (context, snapshot) {
              // Помилка Firebase
              if (snapshot.hasError) {
                return _MessageCard(
                  icon: Icons.error_outline,
                  text: 'Не вдалося завантажити домашнє завдання',
                );
              }

              // Завантаження
              if (!snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final assignments = snapshot.data!;

              // ДЗ немає
              if (assignments.isEmpty) {
                return const _MessageCard(
                  icon: Icons.check_circle_outline,
                  text: 'Домашнього завдання немає',
                );
              }

              // Поки показуємо перше завдання
              final assignment = assignments.first;

              return _AssignmentCard(assignment: assignment);
            },
          ),

          const SizedBox(height: 30),

          // -------------------------
          // МАТЕРІАЛИ
          // -------------------------
          if (subject.link.isNotEmpty && subject.link != '-')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'МАТЕРІАЛИ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: const Row(
                    children: [
                      Icon(Icons.folder_outlined),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          'Матеріали предмету',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),

                      Icon(Icons.open_in_new, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// =====================================================
// КАРТКА ДОМАШНЬОГО ЗАВДАННЯ
// =====================================================

class _AssignmentCard extends StatelessWidget {
  final Assignment assignment;

  const _AssignmentCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  assignment.title,

                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          if (assignment.description.isNotEmpty) ...[
            const SizedBox(height: 10),

            Text(
              assignment.description,

              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                height: 1.4,
              ),
            ),
          ],

          if (assignment.deadline.isNotEmpty) ...[
            const SizedBox(height: 14),

            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 17,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),

                const SizedBox(width: 6),

                Text(
                  'До ${assignment.deadline}',

                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// =====================================================
// КАРТКА, ЯКЩО ДАНИХ НЕМАЄ
// =====================================================

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MessageCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.grey),

          const SizedBox(width: 12),

          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
