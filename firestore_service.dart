import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/announcement.dart';
import '../models/assignment.dart';
import '../models/lesson.dart';
import '../models/subject.dart';

/// Централізований доступ до Firestore.
///
/// Раніше кожен віджет (TodaySchedule, AnnouncementsBlock, SchedulePage)
/// звертався до FirebaseFirestore.instance напряму — тут це зібрано в
/// одне місце, щоб екрани не знали про деталі колекцій.
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  /// Пари на конкретну дату у форматі 'yyyy-MM-dd', відсортовані за часом.
  Stream<List<Lesson>> lessonsForDate(String date) {
    return _db
        .collection('lessons')
        .where('date', isEqualTo: date)
        .snapshots()
        .map((snapshot) {
          final lessons = snapshot.docs
              .map((doc) => Lesson.fromFirestore(doc.id, doc.data()))
              .toList();

          lessons.sort((a, b) => a.startTime.compareTo(b.startTime));

          return lessons;
        });
  }

  /// Усі оголошення, найновіші зверху.
  Stream<List<Announcement>> announcements() {
    return _db.collection('announcements').snapshots().map((snapshot) {
      final announcements = snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc.id, doc.data()))
          .toList();

      announcements.sort((a, b) => b.date.compareTo(a.date));

      return announcements;
    });
  }

  /// Домашні завдання по предмету. Поки не викликається з жодного
  /// екрана — заготовка під наступний етап розробки.
  Stream<List<Assignment>> assignmentsForSubject(String subjectId) {
    return _db
        .collection('assignments')
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .map((snapshot) {
          final result = snapshot.docs
              .map((doc) => Assignment.fromFirestore(doc.id, doc.data()))
              .toList();

          result.sort((a, b) => a.deadline.compareTo(b.deadline));
          return result;
        });
  }

  // предмети
  Stream<List<Subject>> subjects() {
    return _db.collection('subjects').snapshots().map((snapshot) {
      final result = snapshot.docs
          .map((doc) => Subject.fromFirestore(doc.id, doc.data()))
          .toList();

      result.sort((a, b) => a.shortName.compareTo(b.shortName));

      return result;
    });
  }
}
