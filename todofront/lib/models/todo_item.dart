class TodoItem {
  final int? id;
  final String title;
  final String task;
  final DateTime date;
  final String username;

  const TodoItem(
      {required this.title,
      required this.task,
      required this.date,
      required this.username, this.id});

  // Factory constructor to create a TodoItem from JSON
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['heading'] ?? 'No Title',
      task: json['description'] ?? 'No Task',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      username: json['user']['userName'],
    );
  }

  // Optionally, add a method to convert TodoItem to JSON
  Map<String, dynamic> toJson() => {
        'heading': title,
        'description': task,
        'date': date.toIso8601String(),
        'userName': username
      };
}
