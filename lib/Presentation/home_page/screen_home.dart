import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Application/todo_bloc/todo_bloc.dart';
import 'package:todo_app/Presentation/adding_page/screen_add.dart';

ValueNotifier<String> selectedFilterNotifier = ValueNotifier('All ToDos');

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final _debouncer = Debouncer(milliseconds: 1 * 1000);
  final List<String> popupMenuItemsList = [
    'All ToDos',
    'Today\'s ToDos',
    'Completed ToDos',
    'Uncompleted ToDos',
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TodoBloc>(context).add(GetTaskEvent());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'ToDo App',
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return popupMenuItemsList.map((e) {
                return PopupMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList();
            },
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              BlocProvider.of<TodoBloc>(context).add(
                FilterTaskEvent(filterQuery: value),
              );
              selectedFilterNotifier.value = value;
            },
          ),
        ],
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 250,
                child: CupertinoSearchTextField(
                  placeholder: 'Search ToDo items..',
                  itemSize: 15,
                  onChanged: (value) {
                    _debouncer.run(() {
                      BlocProvider.of<TodoBloc>(context).add(
                        SearchTaskEvent(query: value),
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: ValueListenableBuilder(
                    valueListenable: selectedFilterNotifier,
                    builder: (context, newFilter, _) {
                      return Text(
                        newFilter,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
              ),
            ),
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state.isError) {
                  return const Center(
                    child: Text('Error While Fetchig Your Todos..'),
                  );
                }
                if (state.todoList.isEmpty) {
                  return const Center(
                    child: Text('No ToDos..'),
                  );
                } else {
                  return Expanded(
                    child: ListView.separated(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final details = state.todoList[index];
                        return ListTile(
                          leading: Checkbox(
                            value: details.isCompleted,
                            onChanged: (value) {
                              BlocProvider.of<TodoBloc>(context).add(
                                UpdateCompletionEvent(
                                  id: details.id!,
                                  isCompleted: value!,
                                ),
                              );
                            },
                          ),
                          title: Text(details.task),
                          subtitle: Text(details.category),
                          trailing: Column(
                            children: [
                              Text(
                                TimeOfDay.fromDateTime(
                                        DateTime.parse(details.date))
                                    .format(context),
                                style: const TextStyle(color: Colors.green),
                              ),
                              (DateTime.parse(details.date).day ==
                                      DateTime.now().day)
                                  ? const Text(
                                      'Today',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 139, 138, 138),
                                      ),
                                    )
                                  : (DateTime.parse(details.date).day ==
                                          DateTime.now().day - 1)
                                      ? const Text(
                                          'Yesterday',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 139, 138, 138),
                                          ),
                                        )
                                      : (DateTime.parse(details.date).day ==
                                              DateTime.now().day + 1)
                                          ? const Text(
                                              'Tomorrow',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 139, 138, 138),
                                              ),
                                            )
                                          : Text(
                                              details.date.substring(0, 10),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 139, 138, 138),
                                              ),
                                            ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => AddTaskPage(
                                  isUpdate: true,
                                  id: details.id,
                                  task: details.task,
                                  category: details.category,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            BlocProvider.of<TodoBloc>(context).add(
                              DeleteTaskEvent(id: details.id!),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: state.todoList.length,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const AddTaskPage(
                isUpdate: false,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
