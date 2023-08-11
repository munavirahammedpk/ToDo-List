import 'package:todo_app/Domain/task_model.dart';

abstract class ToDoService {
  Future<int>addTask(TaskModel newTask);
  Future <List<TaskModel>>getAllTask();
}