import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';

enum SortBy { name, priority, createdAt }

abstract class AbstractTodoRepository {
  Future<Todo> createTodo(
      {required String name, required TodoPriority priority,});

  /// Returns a list of Todo objects sorted by the provided [sortBy] criteria.
  /// The [sortBy] criteria can be one of [SortBy.name], [SortBy.priority], or [SortBy.createdAt].
  /// If [sortBy] is set to [SortBy.createdAt], the returned list will not be sorted.
  ///
  /// @param sortBy: The criteria by which the Todo list will be sorted.
  ///
  /// @return Future<List<Todo>>: returns a list of Todo objects sorted by the provided [sortBy] criteria.
  Future<List<Todo>> getTodos(SortBy sortBy);

  Future<void> updateTodo(
      {required String id,
      TodoPriority? priority,
      String? name,
      bool? isCompleted,});

  Future<void> deleteTodo({required id});
}
