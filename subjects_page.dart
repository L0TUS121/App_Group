import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../services/firestore_service.dart';
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

                    fillColor: Theme.of(context).colorScheme.surfaceContainer,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Subject>>(
              stream: FirestoreService.instance.subjects(),

              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Не вдалося завантажити предмети'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final query = searchQuery.trim().toLowerCase();

                final filtered = snapshot.data!.where((subject) {
                  return subject.shortName.toLowerCase().contains(query) ||
                      subject.fullName.toLowerCase().contains(query) ||
                      subject.lectureTeacher.toLowerCase().contains(query) ||
                      subject.practiceTeacher.toLowerCase().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Нічого не знайдено'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),

                  itemCount: filtered.length,

                  separatorBuilder: (_, _) => const SizedBox(height: 10),

                  itemBuilder: (context, index) {
                    final subject = filtered[index];

                    return SubjectCard(
                      subject: subject,

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                SubjectDetailsPage(subject: subject),
                          ),
                        );
                      },
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
