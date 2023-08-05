import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final List dropDownItemsList = [
    'Personal',
    'Shopping',
    'Work',
    'Health',
  ];

  TextEditingController newCategory = TextEditingController();
  DateTime? selectedDate;
  String? selectedTime;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Item'),
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
                      onPressed: () {},
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task',
                    hintText: 'Enter a new task',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: dropDownItemsList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  hint: const Text('Select a Category'),
                  onChanged: (value) {},
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
                   final selectedTimeTemp=await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTimeTemp==null) {
                      return;
                    }
                    setState(() {
                      
                      selectedTime=selectedTimeTemp.format(context).toString();
                    });
                  },
                  icon: const Icon(Icons.watch_later_outlined),
                  label:  Text(selectedTime==null?'Select Time for Notification':selectedTime.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addNewCategory(BuildContext context) async {
    showDialog(
      context: context,
      builder: ((context) {
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
                      dropDownItemsList.add(newCategory.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
