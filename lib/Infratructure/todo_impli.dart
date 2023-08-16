import 'package:todo_app/Domain/todo_service.dart';
import 'package:todo_app/Domain/task_model.dart';
import 'package:todo_app/Infratructure/sqflite_db/db.dart';
import 'package:todo_app/Presentation/adding_page/screen_add.dart';

List<TaskModel> taskList = [];
List<String> categoryList = [];

class ToDoImplemetation implements ToDoService {
  @override
  Future<int> addTask(TaskModel newTask) async {
    final insertedId = db.rawInsert(
        'INSERT INTO todos(task,category,date,time,isCompleted) VALUES (?, ?, ?, ?, ?)',
        [
          newTask.task,
          newTask.category,
          newTask.date.toString(),
          newTask.time.toString(),
          0,
        ]);
    return insertedId;
  }

  @override
  Future<List<TaskModel>> getAllTask() async {
    taskList.clear();
    final values = await db.rawQuery('SELECT * FROM todos');
    for (var map in values) {
      taskList.add(
        TaskModel.fromMap(map),
      );
    }
    return taskList;
  }

  @override
  Future<int> deleteTask(int id) async {
    return await db.rawDelete('DELETE FROM todos WHERE id = ?', [id]);
  }

  @override
  Future<void> addNewCategory(String category) async {
    await db.rawInsert('INSERT INTO category(category) VALUES(?)', [category]);
  }

  @override
  Future<List<String>> getAllCategories() async {
    categoryList.clear();
    final values = await db.rawQuery('SELECT * FROM category');

    for (var map in values) {
      categoryList.add(map['category'].toString());
    }
    categoryList.sort(((a, b) => b.compareTo(a)));
    categoryList.addAll(dropDownItemsList.toList());

    return categoryList;
  }

  @override
  Future<void> updateCompletion(int id, bool isCompleted) async {
    await db.rawUpdate('UPDATE todos SET isCompleted=? WHERE id=?',
        [isCompleted == true ? 1 : 0, id]);
    //print(int.tryParse(isCompleted.toString()));
  }
}
