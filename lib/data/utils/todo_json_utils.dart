import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';

class TodoJSONUtils {
  static Map<String, dynamic> fromTodoToDatabaseJSON(Todo todo) =>
      <String, dynamic>{
        kId: todo.id,
        kName: todo.name,
        kIsCompleted: todo.isCompleted ? 1 : 0,
        kPriority: fromTodoPriorityToInt(todo.priority),
      };

  static Todo fromDatabaseJSONToTodo(Map<String, dynamic> json) => Todo(
        id: json[kId] as String,
        name: json[kName] as String,
        isCompleted: json[kIsCompleted] == 1,
        priority: fromIntToTodoPriority(json[kPriority]),
      );

  static String fromTodoPriorityToString(TodoPriority todoPriority) {
    switch (todoPriority) {
      case TodoPriority.high:
        return 'high';
      case TodoPriority.medium:
        return 'medium';
      case TodoPriority.low:
      default:
        return 'low';
    }
  }

  static int fromTodoPriorityToInt(TodoPriority todoPriority) {
    switch (todoPriority) {
      case TodoPriority.high:
        return 0;
      case TodoPriority.medium:
        return 1;
      case TodoPriority.low:
      default:
        return 2;
    }
  }

  static TodoPriority fromIntToTodoPriority(int priorityInt) {
    switch (priorityInt) {
      case 0:
        return TodoPriority.high;
      case 1:
        return TodoPriority.medium;
      case 2:
      default:
        return TodoPriority.low;
    }
  }
}
