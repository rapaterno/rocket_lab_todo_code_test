import 'package:get_it/get_it.dart';
import 'package:rocket_lab_todo_code_test/presentation/injector/blocs.dart';
import 'package:rocket_lab_todo_code_test/presentation/injector/database.dart';
import 'package:rocket_lab_todo_code_test/presentation/injector/repositories.dart';

GetIt injector = GetIt.instance;
void setupInjectors() {
  initDatabases();
  initRepositories();
  initBlocs();
}
