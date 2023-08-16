import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Application/todo_bloc/todo_bloc.dart';
import 'package:todo_app/Presentation/adding_page/screen_add.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      size: 30,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 250,
                child: CupertinoSearchTextField(
                  placeholder: 'Search ToDo items..',
                  itemSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'All ToDos',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final details = state.todoList[index];
                        return ListTile(
                          leading: Checkbox(
                            value: details.isCompleted,
                            onChanged: (value) {
                              BlocProvider.of<TodoBloc>(context).add(
                                UpdateCompletion(
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
                                details.time,
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
              builder: (context) => const AddTaskPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
