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

bool isEnableNotification = true;

class AddTaskPage extends StatefulWidget {
  final bool isUpdate;
  final int? id;
  final String? task;
  final String? category;

  const AddTaskPage({
    super.key,
    required this.isUpdate,
    this.id,
    this.task,
    this.category,
  });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController newCategory = TextEditingController();
  TextEditingController taskTextController = TextEditingController();
  String? selectedCategory;
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodoBloc>(context).add(GetAllCategoryEvent());
    if (widget.isUpdate) {
      taskTextController.text = widget.task!;
      selectedCategory = widget.category;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: (widget.isUpdate)
              ? const Text('Edit Task')
              : const Text('Add Task'),
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
                      onPressed: () {
                        if (taskTextController.text.isEmpty) {
                          return;
                        }
                        if (selectedCategory == null) {
                          return;
                        }
                        if (selectedDateTime == null) {
                          return;
                        }
                      
                        if (selectedDateTime!.compareTo(DateTime.now())==0 || selectedDateTime!.compareTo(DateTime.now())<0) {
                          return;
                        }

                        if (widget.isUpdate) {
                          final updatedTask = updateTask();
                          BlocProvider.of<TodoBloc>(context).add(
                            UpdateTaskEvent(
                              updatedTask: updatedTask,
                              isEnableNotification: isEnableNotification,
                            ),
                          );
                        } else {
                          final addedTask = addTAsk();
                          BlocProvider.of<TodoBloc>(context).add(AddTaskEvent(
                            newTask: addedTask,
                            isEnableNotification: isEnableNotification,
                          ));
                        }

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
                      value: selectedCategory,
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
                      hint: const Text('Select Category'),
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
                    final selectedDateTimeTemp = await pickDateTime();
                    setState(() {
                      selectedDateTime = selectedDateTimeTemp;
                    });
                  },
                  icon: const Icon(Icons.date_range_outlined),
                  label: Text(
                    selectedDateTime == null
                        ? 'Select Date and Time'
                        : selectedDateTime.toString(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enable Notification :',
                    ),
                    Switch.adaptive(
                      value: isEnableNotification,
                      onChanged: (newValue) {
                        setState(() {
                          isEnableNotification = newValue;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) {
      return;
    }
    TimeOfDay? time = await pickTime();
    if (time == null) {
      return;
    }
    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return dateTime;
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

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

  TaskModel addTAsk() {
    return TaskModel(
      task: taskTextController.text,
      category: selectedCategory!,
      date: selectedDateTime.toString(),
      isCompleted: false,
    );
  }

  TaskModel updateTask() {
    return TaskModel(
      id: widget.id,
      task: taskTextController.text,
      category: selectedCategory!,
      date: selectedDateTime.toString(),
      isCompleted: false,
    );
  }
}
