import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Application/todo_bloc/todo_bloc.dart';

import '../../Domain/task_model.dart';

final List<String> dropDownItemsList = [
  'Personal',
  'Shopping',
  'Work',
  'Health',
];

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController newCategory = TextEditingController();
  TextEditingController taskTextController = TextEditingController();
  String? selectedCategory;
  DateTime? selectedDate;
  String? selectedTime;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodoBloc>(context).add(GetAllCategoryEvent());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (taskTextController.text.isEmpty) {
                          return;
                        }
                        if (selectedCategory == null) {
                          return;
                        }
                        if (selectedDate == null) {
                          return;
                        }
                        if (selectedTime == null) {
                          return;
                        }
                        final addedTask = await addTAsk();
                        //context.read<TodoBloc>().add(AddTaskEvent(newTask: addedTask));

                        BlocProvider.of<TodoBloc>(context)
                            .add(AddTaskEvent(newTask: addedTask));
                        Navigator.pop(context);
                        BlocProvider.of<TodoBloc>(context).add(GetTaskEvent());
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: taskTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task',
                    hintText: 'Enter a new task',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    return DropdownButtonFormField(
                      borderRadius: BorderRadius.circular(20),
                      menuMaxHeight: 200,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: state.category.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      hint: const Text('Select a Category'),
                      onChanged: (value) {
                        selectedCategory = value.toString();
                      },
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () async {
                      addNewCategory(context);
                    },
                    child: const Text('Add Category'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(
                        DateTime.now().year + 1,
                        DateTime.now().month,
                      ),
                    );
                    if (selectedDateTemp == null) {
                      return;
                    }
                    setState(() {
                      selectedDate = selectedDateTemp;
                    });
                  },
                  icon: const Icon(Icons.date_range_outlined),
                  label: Text(
                    selectedDate == null
                        ? 'Select a Date'
                        : selectedDate.toString().substring(0, 10),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 236, 15, 126))),
                  onPressed: () async {
                    final selectedTimeTemp = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTimeTemp == null) {
                      return;
                    }
                    setState(() {
                      selectedTime =
                          selectedTimeTemp.format(context).toString();
                    });
                  },
                  icon: const Icon(Icons.watch_later_outlined),
                  label: Text(selectedTime == null
                      ? 'Select Time for Notification'
                      : selectedTime.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addNewCategory(BuildContext context1) async {
    showDialog(
      context: context1,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: newCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TodoBloc>(context1)
                          .add(AddNewCategoryEvent(category: newCategory.text));
                      Navigator.pop(context);
                      BlocProvider.of<TodoBloc>(context1)
                          .add(GetAllCategoryEvent());
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<TaskModel> addTAsk() async {
    return TaskModel(
      task: taskTextController.text,
      category: selectedCategory!,
      date: selectedDate.toString(),
      time: selectedTime.toString(),
      isCompleted: false,
    );
  }
}
