import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const kTodoTableDbName = 'todo.db';
const kPriority = 'priority';
const kIsCompleted = 'is_completed';
const kName = 'name';
const kId = 'id';

class DatabaseProvider {
  Database? _database;

  //Migration Script to easier manage table versions and database modifications
  final Map<int, String> _migrationScripts = {
    1: '''CREATE TABLE todos(
    $kId TEXT PRIMARY KEY,
    $kName TEXT,
    $kIsCompleted INTEGER,
    $kPriority INTEGER
  )'''
  };

  ///Get function to create a database if [_database] is uninitialized
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await createDatabase();
      return _database!;
    }
  }

  Future<Database> createDatabase() async {
    int migrationVersion = _migrationScripts.length;

    String path = join(await getDatabasesPath(), kTodoTableDbName);
    return openDatabase(path, version: migrationVersion, onCreate: initDB);
  }

  void initDB(Database db, int version) async {
    int migrationVersion = _migrationScripts.length;

    for (int i = 1; i <= migrationVersion; i++) {
      await db.execute(_migrationScripts[i]!);
    }
  }

  static deleteTodoDatabase() async {
    String path = join(await getDatabasesPath(), kTodoTableDbName);
    deleteDatabase(path);
  }
}
