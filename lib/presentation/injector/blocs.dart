import 'package:rocket_lab_todo_code_test/data/repository/impl/todo_repository.dart';
import 'package:rocket_lab_todo_code_test/domain/todo/cubit/todo_cubit.dart';
import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';

void initBlocs() {
  injector.registerLazySingleton<TodoCubit>(
      () => TodoCubit(repository: injector<TodoRepository>()),);
}
