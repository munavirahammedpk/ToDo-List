import 'package:sqflite/sqflite.dart';

late Database db;
Future<void> initializeDatabase() async {
  db = await openDatabase(
    'student.db',
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE todos (id INTEGER PRIMARY KEY, task TEXT, category TEXT, date TEXT, isCompleted BOOLEAN)',
      );
      await db.execute(
        'CREATE TABLE category (id INTEGER PRIMARY KEY, category TEXT)',
      );
    },
  );
}
