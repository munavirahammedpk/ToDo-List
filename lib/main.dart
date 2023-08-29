import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:todo_app/Infratructure/sqflite_db/db.dart';
import 'package:todo_app/Presentation/home_page/screen_home.dart';
import 'Application/todo_bloc/todo_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDatabase();
  initializeTimeZones();
  notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings iosInitializationSettings =
      const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestCriticalPermission: true,
    requestBadgePermission: true,
  );

  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosInitializationSettings);

  await notificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: MaterialApp(
        title: 'ToDo App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomePage(),
      ),
    );
  }
}
