import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/repository/abstract_todo_repository.dart';

abstract class TestUtils {
  static String priorityString(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return 'high';
      case TodoPriority.medium:
        return 'medium';
      case TodoPriority.low:
        return 'low';
    }
  }

  static String sortByString(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.createdAt:
        return 'created at';
      case SortBy.name:
        return 'name';
      case SortBy.priority:
        return 'priority';
    }
  }
}
