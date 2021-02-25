import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//if not exists
final String tableName = "Rating";
// ignore: non_constant_identifier_names
final String Column_id = "ID";
// ignore: non_constant_identifier_names
final String Column_rating = "Rating";

class TaskModelRating {
  final String rating;
  int id;

  TaskModelRating({
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      Column_rating: this.rating,
    };
  }
}

class TodoHelperRating {
  Database db;

  TodoHelperRating() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "database.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTEGER PRIMARY KEY AUTOINCREMENT, $Column_rating TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModelRating task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<List<TaskModelRating>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    return List.generate(tasks.length, (i) {
      return TaskModelRating(
        rating: tasks[i][Column_rating],
        id: tasks[i][Column_id],
      );
    });
  }
}
