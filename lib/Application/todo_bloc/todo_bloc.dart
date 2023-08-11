import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Domain/task_model.dart';
import 'package:todo_app/Infratructure/todo_impli.dart';

part 'todo_event.dart';
part 'todo_state.dart';

ToDoImplemetation toDoImplemetation = ToDoImplemetation();

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc()
      : super(
          TodoState.initial(
            isLoading: true,
            isError: false,
            todoList: [],
            category: [],
          ),
        ) {
    on<AddTaskEvent>((event, emit) async {
      await toDoImplemetation.addTask(event.newTask);
    });
    on<GetTaskEvent>(
      (event, emit) async {
        print('screen build');
        if (state.todoList.isEmpty) {
          emit(
            TodoState(
              isLoading: true,
              isError: false,
              todoList: [],
              category: [],
            ),
          );
        }

        final valueList = await toDoImplemetation.getAllTask();
        emit(
          TodoState(
            isLoading: false,
            isError: false,
            todoList: valueList,
            category: [],
          ),
        );
      },
    );
  }
}
