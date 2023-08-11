import 'package:sqflite/sqflite.dart';

late Database db;
Future<void> initializeDatabase() async {
  db =await  openDatabase(
    'student.db',
    version: 1,
    onCreate: (Database db, int version) {
      db.execute(
        'CREATE TABLE student (id INTEGER PRIMARY KEY, task TEXT, category TEXT, date TEXT, time TEXT)',
      );
    },
  );
}
