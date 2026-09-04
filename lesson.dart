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

/// Людська назва типу пари: 'lecture' -> 'Лекція' тощо.
String lessonTypeName(String type) {
  switch (type.toLowerCase()) {
    case 'lecture':
      return 'Лекція';
    case 'practice':
      return 'Практична';
    case 'lab':
      return 'Лабораторна';
    case 'group':
      return 'Групова';
    default:
      return type;
  }
}
