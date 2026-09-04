class Assignment {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final String dueDate; // формат 'yyyy-MM-dd'
  final bool isDone;

  const Assignment({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isDone = false,
  });

  factory Assignment.fromFirestore(String id, Map<String, dynamic> data) {
    return Assignment(
      id: id,
      subjectId: data['subjectId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: data['dueDate'] ?? '',
      isDone: data['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isDone': isDone,
    };
  }
}
