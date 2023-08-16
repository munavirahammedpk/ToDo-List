import 'package:todo_app/Domain/task_model.dart';

abstract class ToDoService {
  Future<int>addTask(TaskModel newTask);
  Future <List<TaskModel>>getAllTask();
  Future <int>deleteTask(int id);
  Future<void> addNewCategory(String category);
  Future <List>getAllCategories();
  Future<void>updateCompletion(int id,bool isCompleted);
}