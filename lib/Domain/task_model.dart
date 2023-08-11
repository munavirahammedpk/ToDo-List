
class TaskModel {
  int? id;
  final String task;
  final String category;
  final String date;
  final String time;

  TaskModel({
    this.id,
    required this.task,
    required this.category,
    required this.date,
    required this.time,
  });

  static TaskModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final task = map['task'] as String;
    final category = map['category'] as String;
    final date = map['date'] ;
    final time = map['time'] ;

    return TaskModel(
      id: id,
      task: task,
      category: category,
      date: date.toString(),
      time: time.toString(),
    );
  }
}
