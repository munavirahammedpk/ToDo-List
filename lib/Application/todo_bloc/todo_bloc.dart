import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      await toDoImplemetation.addTask(event.newTask).then((id) async {
        if (event.isEnableNotification) {
          await toDoImplemetation.scheduleNotification(
            id,
            event.newTask.task,
            event.newTask.category,
            DateTime.parse(event.newTask.date),
          );
        }
      });
    });
    on<GetTaskEvent>((event, emit) async {
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
    });
    on<UpdateTaskEvent>((event, emit) async {
      await toDoImplemetation.updateTask(event.updatedTask).then((id) async {
        if (event.isEnableNotification) {
          await toDoImplemetation.scheduleNotification(
            event.updatedTask.id!,
            event.updatedTask.task,
            event.updatedTask.category,
            DateTime.parse(event.updatedTask.date),
          );
        }
      });
    });
    on<DeleteTaskEvent>((event, emit) async {
      emit(
        TodoState(
          isLoading: true,
          isError: false,
          todoList: state.todoList,
          category: [],
        ),
      );
      await toDoImplemetation.deleteTask(event.id);
      final valueList = await toDoImplemetation.getAllTask();
      emit(
        TodoState(
          isLoading: false,
          isError: false,
          todoList: valueList,
          category: [],
        ),
      );
    });
    on<AddNewCategoryEvent>((event, emit) async {
      await toDoImplemetation.addNewCategory(event.category);
    });

    on<GetAllCategoryEvent>((event, emit) async {
      emit(TodoState(
        isLoading: true,
        isError: false,
        todoList: state.todoList,
        category: [],
      ));
      final categoryList = await toDoImplemetation.getAllCategories();
      emit(TodoState(
        isLoading: false,
        isError: false,
        todoList: state.todoList,
        category: categoryList,
      ));
    });

    on<UpdateCompletionEvent>((event, emit) async {
      emit(TodoState(
        isLoading: true,
        isError: false,
        todoList: state.todoList,
        category: state.category,
      ));
      await toDoImplemetation
          .updateCompletion(event.id, event.isCompleted)
          .then((value) async {
        final valueList = await toDoImplemetation.getAllTask();
        emit(TodoState(
          isLoading: false,
          isError: false,
          todoList: valueList,
          category: state.category,
        ));
      });
    });
    on<SearchTaskEvent>((event, emit) async {
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

      List<TaskModel> valueList = await toDoImplemetation.getAllTask();

      valueList = valueList
          .where(
            (element) => element.task.toLowerCase().contains(event.query),
          )
          .toList();
      emit(
        TodoState(
          isLoading: false,
          isError: false,
          todoList: valueList,
          category: [],
        ),
      );
    });
    on<FilterTaskEvent>((event, emit) async {
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

      final valueList = await toDoImplemetation.filterTask(event.filterQuery);
      emit(
        TodoState(
          isLoading: false,
          isError: false,
          todoList: valueList,
          category: [],
        ),
      );
    });
  }
}
