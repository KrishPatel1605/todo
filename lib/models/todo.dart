class Todo {
  final String id;
  final String userId;
  String title;
  DateTime deadline;
  bool isDone;

  Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.deadline,
    required this.isDone,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'].toString(),
      userId: map['user_id'],
      title: map['title'] ?? '',
      deadline: DateTime.parse(map['deadline']).toLocal(),
      isDone: map['is_done'] ?? false,
    );
  }
}
