class Assignment {
  final String id;
  final String subjectId;
  final String title;
  final String deadline;
  final String description;

  const Assignment({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.deadline,
    required this.description,
  });

  factory Assignment.fromFirestore(String id, Map<String, dynamic> data) {
    return Assignment(
      id: id,
      subjectId: data['subjectId'] ?? '',
      title: data['title'] ?? '',
      deadline: data['deadline'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
