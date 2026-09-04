class Announcement {
  final String id;
  final String title;
  final String message;
  final String date;

  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
  });

  factory Announcement.fromFirestore(String id, Map<String, dynamic> data) {
    return Announcement(
      id: id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      date: data['date'] ?? '',
    );
  }
}
