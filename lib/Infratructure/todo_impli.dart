import 'package:todo_app/Domain/todo_service.dart';
import 'package:todo_app/Domain/task_model.dart';
import 'package:todo_app/Infratructure/sqflite_db/db.dart';

List<TaskModel> taskList = [];

class ToDoImplemetation implements ToDoService {
  @override
  Future<int> addTask(TaskModel newTask) async {
    final insertedId = db.rawInsert(
        'INSERT INTO student(task,category,date,time) VALUES (?, ?, ?, ?)', [
      newTask.task,
      newTask.category,
      newTask.date.toString(),
      newTask.time.toString(),
    ]);
    return insertedId;
  }

  @override
  Future<List<TaskModel>> getAllTask() async {
    taskList.clear();

    final values = await db.rawQuery('SELECT * FROM student');

    for (var map in values) {
      taskList.add(
        TaskModel.fromMap(map),
      );
    }
    return taskList;
  }
}
