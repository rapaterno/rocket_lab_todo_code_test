import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/repository/abstract_todo_repository.dart';
import 'package:rocket_lab_todo_code_test/data/repository/impl/database_todo_repository.dart';

class TodoRepository implements AbstractTodoRepository {
  final DatabaseTodoRepository databaseTodoRepository;
  TodoRepository(this.databaseTodoRepository);

  @override
  Future<Todo> createTodo(
      {required String name, required TodoPriority priority,}) async {
    return await databaseTodoRepository.createTodo(
        name: name, priority: priority,);
  }

  @override
  Future<void> deleteTodo({required id}) async {
    await databaseTodoRepository.deleteTodo(id: id);
  }

  @override
  Future<void> updateTodo(
      {required String id,
      TodoPriority? priority,
      String? name,
      bool? isCompleted,}) async {
    await databaseTodoRepository.updateTodo(
        id: id, priority: priority, name: name, isCompleted: isCompleted,);
  }

  @override
  Future<List<Todo>> getTodos(SortBy sortBy) async {
    return await databaseTodoRepository.getTodos(sortBy);
  }
}
