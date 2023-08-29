part of 'todo_bloc.dart';

@immutable
class TodoEvent {}

class AddTaskEvent extends TodoEvent {
  final TaskModel newTask;
  final bool isEnableNotification;

  AddTaskEvent({
    required this.newTask,
    required this.isEnableNotification,
  });
}

class GetTaskEvent extends TodoEvent {}

class DeleteTaskEvent extends TodoEvent {
  final int id;

  DeleteTaskEvent({required this.id});
}

class AddNewCategoryEvent extends TodoEvent {
  final String category;

  AddNewCategoryEvent({required this.category});
}

class GetAllCategoryEvent extends TodoEvent {}

class UpdateCompletionEvent extends TodoEvent {
  final int id;
  final bool isCompleted;

  UpdateCompletionEvent({
    required this.id,
    required this.isCompleted,
  });
}

class UpdateTaskEvent extends TodoEvent {
  final TaskModel updatedTask;
  final bool isEnableNotification;

  UpdateTaskEvent({
    required this.updatedTask,
    required this.isEnableNotification,
  });
}

class SearchTaskEvent extends TodoEvent {
  final String query;

  SearchTaskEvent({required this.query});
}

class FilterTaskEvent extends TodoEvent {
  final String filterQuery;
  FilterTaskEvent({required this.filterQuery});
}
