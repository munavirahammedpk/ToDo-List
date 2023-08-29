import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:todo_app/Domain/todo_service.dart';
import 'package:todo_app/Domain/task_model.dart';
import 'package:todo_app/Infratructure/sqflite_db/db.dart';
import 'package:todo_app/Presentation/adding_page/screen_add.dart';

import '../main.dart';

List<TaskModel> taskList = [];
List<String> categoryList = [];

class ToDoImplemetation implements ToDoService {
  @override
  Future<int> addTask(TaskModel newTask) async {
    final insertedId = db.rawInsert(
      'INSERT INTO todos(task,category,date,isCompleted) VALUES (?, ?, ?, ?)',
      [
        newTask.task,
        newTask.category,
        newTask.date.toString(),
        0,
      ],
    );

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
  }

  @override
  Future<void> updateTask(TaskModel updatedTask) async {
    await db.rawUpdate('UPDATE todos SET task=?,category=?,date=? WHERE id=?', [
      updatedTask.task,
      updatedTask.category,
      updatedTask.date,
      updatedTask.id
    ]);
  }

  @override
  Future<List<TaskModel>> filterTask(String filterQuery) async {
    taskList.clear();
    if (filterQuery == 'All ToDos') {
      final values = await db.rawQuery('SELECT * FROM todos');
      for (var map in values) {
        taskList.add(
          TaskModel.fromMap(map),
        );
      }
    } else if (filterQuery == 'Today\'s ToDos') {
      final values = await db.rawQuery('SELECT * FROM todos');
      for (var map in values) {
        taskList.add(
          TaskModel.fromMap(map),
        );
      }
      taskList = taskList
          .where((element) =>
              element.date.substring(0, 10).contains(DateTime.now().toString().substring(0,10)))
          .toList();
    } else if (filterQuery == 'Completed ToDos') {
      final values =
          await db.rawQuery('SELECT * FROM todos WHERE isCompleted=1');
      for (var map in values) {
        taskList.add(
          TaskModel.fromMap(map),
        );
      }
    } else {
      final values =
          await db.rawQuery('SELECT * FROM todos WHERE isCompleted=0');
      for (var map in values) {
        taskList.add(
          TaskModel.fromMap(map),
        );
      }
    }
    return taskList;
  }

  @override
  Future<void> scheduleNotification(
      int id, String? title, String? body, DateTime dateTime) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'todo-notification',
      'ToDo App Notification',
      priority: Priority.max,
      importance: Importance.max,
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      TZDateTime.from(
        dateTime.add(const Duration(seconds: 10)),
        local,
      ),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
