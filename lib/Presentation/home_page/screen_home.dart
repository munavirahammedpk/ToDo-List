import 'package:flutter/material.dart';
import 'package:todo_app/Presentation/adding_page/screen_add.dart';
import 'package:todo_app/Presentation/completed_page/screen_completed.dart';

final List<BottomNavigationBarItem> pageList = [
  BottomNavigationBarItem(icon: Icon(Icons.home),),
  BottomNavigationBarItem(icon: Icon(Icons.add),),
  BottomNavigationBarItem(icon: Icon(Icons.history),),
  
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo List'),
        ),
        body: Column(
          children: const [Text('Today\'s tasks')],
        ),
        bottomNavigationBar: BottomNavigationBar(items: pageList),
      ),
    );
  }
}
