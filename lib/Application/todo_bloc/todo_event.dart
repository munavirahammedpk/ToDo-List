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
