import 'package:flutter/material.dart';

import '../models/subject.dart';
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
