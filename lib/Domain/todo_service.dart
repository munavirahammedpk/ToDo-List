import 'package:todo_app/Domain/task_model.dart';

abstract class ToDoService {
  Future<int> addTask(TaskModel newTask);
  Future<void> updateTask(TaskModel updatedTask);
  Future<List<TaskModel>> getAllTask();
  Future<int> deleteTask(int id);
  Future<void> addNewCategory(String category);
  Future<List> getAllCategories();
  Future<void> updateCompletion(int id, bool isCompleted);
  Future<List<TaskModel>> filterTask( String filterQuery);
  Future<void> scheduleNotification(int id, String? title, String? body,DateTime dateTime);
}
