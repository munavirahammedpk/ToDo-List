part of 'todo_bloc.dart';

class TodoState {
  bool isLoading;
  bool isError;
  List<TaskModel> todoList;
  List category;

  TodoState({
    required this.isLoading,
    required this.isError,
    required this.todoList,
    required this.category,
  });

  TodoState.initial({
    required this.isLoading,
    required this.isError,
    required this.todoList,
    required this.category,
  }) {
    isLoading = true;
    isError = false;
    taskList = [];
    category = [];
  }
}
