import 'package:clock/clock.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/repository/abstract_todo_repository.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';
import 'package:rocket_lab_todo_code_test/data/utils/todo_json_utils.dart';
import 'package:uuid/uuid.dart';

const kTodoTable = 'todos';
const kPageLimit = 10;

class DatabaseTodoRepository implements AbstractTodoRepository {
  final DatabaseProvider _databaseProvider;

  DatabaseTodoRepository(this._databaseProvider);
  @override
  Future<Todo> createTodo({
    required String name,
    required TodoPriority priority,
  }) async {
    final db = await _databaseProvider.database;

    const uuid = Uuid();
    final id = uuid.v1(
      options: {
        'node': [0, 0, 0, 0, 0, 0],
        'mSecs': clock.now().millisecondsSinceEpoch,
        'nSecs': 0
      },
    );
    final todoItem =
        Todo(id: id, name: name, isCompleted: false, priority: priority);

    await db.insert(kTodoTable, TodoJSONUtils.fromTodoToDatabaseJSON(todoItem));

    return todoItem;
  }

  @override
  Future<void> deleteTodo({required id}) async {
    final db = await _databaseProvider.database;
    await db.delete(kTodoTable, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Todo>> getTodos(SortBy sortBy) async {
    final db = await _databaseProvider.database;

    String? orderBy;
    switch (sortBy) {
      case SortBy.name:
        orderBy = kName;
        break;
      case SortBy.priority:
        orderBy = kPriority;
        break;
      case SortBy.createdAt:
        orderBy = null;
        break;
    }

    final List<Map<String, dynamic>> result = await db.query(
      kTodoTable,
      orderBy: orderBy,
    );
    return List.generate(
      result.length,
      (i) => TodoJSONUtils.fromDatabaseJSONToTodo(result[i]),
    );
  }

  @override
  Future<void> updateTodo({
    required String id,
    TodoPriority? priority,
    String? name,
    bool? isCompleted,
  }) async {
    final db = await _databaseProvider.database;

    final updateMap = {
      if (priority != null)
        kPriority: TodoJSONUtils.fromTodoPriorityToInt(priority),
      if (isCompleted != null) kIsCompleted: isCompleted ? 1 : 0,
      if (name != null) kName: name,
    };

    await db.update(
      kTodoTable,
      updateMap,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
