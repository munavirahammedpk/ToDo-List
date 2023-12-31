class TaskModel {
  int? id;
  final String task;
  final String category;
  final String date;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.task,
    required this.category,
    required this.date,
    required this.isCompleted,
  });

  static TaskModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final task = map['task'] as String;
    final category = map['category'] as String;
    final date = map['date'];
    final isCompleted = map['isCompleted'];

    return TaskModel(
      id: id,
      task: task,
      category: category,
      date: date.toString(),
      isCompleted: isCompleted != 0,
    );
  }
}
