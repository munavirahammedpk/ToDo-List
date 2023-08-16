part of 'todo_bloc.dart';

@immutable
class TodoEvent {}

class AddTaskEvent extends TodoEvent {
  final TaskModel newTask;

  AddTaskEvent({
    required this.newTask,
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

class UpdateCompletion extends TodoEvent {
  final int id;
  final bool isCompleted;

  UpdateCompletion({
    required this.id,
    required this.isCompleted,
  });
}
