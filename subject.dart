class Subject {
  final String id;
  final String shortName;
  final String fullName;
  final String lectureTeacher;
  final String lecturePhone;
  final String practiceTeacher;
  final String practicePhone;
  final String link;

  const Subject({
    required this.id,
    required this.shortName,
    required this.fullName,
    required this.lectureTeacher,
    required this.lecturePhone,
    required this.practiceTeacher,
    required this.practicePhone,
    required this.link,
  });

  factory Subject.fromFirestore(String id, Map<String, dynamic> data) {
    return Subject(
      id: id,
      shortName: data['shortName'] ?? '',
      fullName: data['fullName'] ?? '',
      lectureTeacher: data['lectureTeacher'] ?? '',
      lecturePhone: data['lecturePhone'] ?? '',
      practiceTeacher: data['practiceTeacher'] ?? '',
      practicePhone: data['practicePhone'] ?? '',
      link: data['link'] ?? '',
    );
  }
}
