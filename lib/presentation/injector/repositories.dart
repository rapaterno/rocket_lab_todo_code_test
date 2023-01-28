import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';
import 'package:rocket_lab_todo_code_test/data/repository/impl/database_todo_repository.dart';
import 'package:rocket_lab_todo_code_test/data/repository/impl/todo_repository.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';

void initRepositories() {
  injector.registerLazySingleton(
      () => DatabaseTodoRepository(injector<DatabaseProvider>()),);
  injector.registerLazySingleton(
      () => TodoRepository(injector<DatabaseTodoRepository>()),);
}
