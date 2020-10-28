import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//if not exists
final String tableName = "KuraCek";
// ignore: non_constant_identifier_names
final String Column_id = "ID";
// ignore: non_constant_identifier_names
final String Column_kuraList = "KuraList";
// ignore: non_constant_identifier_names
final String Column_name = "name";

class TaskModel {
  final String name;
  final String kuraList;
  int id;

  TaskModel({
    this.kuraList,
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      Column_name: this.name,
      Column_kuraList: this.kuraList,
    };
  }
}

class TodoHelper {
  Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "databse.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT,$Column_name TEXT, $Column_kuraList TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<void> deleteTask(int x) async {
    try {
      db.execute(
        'DELETE FROM $tableName WHERE $Column_id = ? ',
        [x],
      );
    } catch (_) {
      print(_);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    return List.generate(tasks.length, (i) {
      return TaskModel(
        name: tasks[i][Column_name],
        kuraList: tasks[i][Column_kuraList],
        id: tasks[i][Column_id],
      );
    });
  }
}
