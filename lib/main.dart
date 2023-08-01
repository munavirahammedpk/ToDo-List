import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_app/Presentation/adding_page/screen_add.dart';
import 'package:todo_app/Presentation/home_page/screen_home.dart';

import 'Presentation/completed_page/screen_completed.dart';

void main() {
  runApp(const MyApp());
}

ValueNotifier bottomListIndex = ValueNotifier(0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  final List<Widget> pageList = const [
    HomePage(),
    CompletedTaskPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo List'),
        elevation: 5,
      ),
      body: ValueListenableBuilder(
        valueListenable: bottomListIndex,
        builder: (context, newIndx, _) {
          return pageList[newIndx];
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.of(context).push(CupertinoPageRoute(builder: (context){
          return const AddTaskPage();
        }));
      },
      backgroundColor: Colors.purple,
      child:const Icon(Icons.add),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: bottomListIndex,
          builder: (context, newIndex, _) {
            return BottomNavigationBar(
              elevation: 5,
              iconSize: 30,
              selectedFontSize: 16,
              selectedItemColor: Colors.purple,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                ),
              ],
              currentIndex: bottomListIndex.value,
              onTap: (value) {
                bottomListIndex.value = value;
                bottomListIndex.notifyListeners();
              },
            );
          }),
    );
  }
}
