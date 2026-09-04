import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../widgets/page_header.dart';
import '../widgets/subject_card.dart';
import 'subject_details_page.dart';

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
