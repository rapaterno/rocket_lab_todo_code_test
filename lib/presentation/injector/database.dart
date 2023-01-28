import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';

void initDatabases() {
  injector.registerLazySingleton<DatabaseProvider>(() => DatabaseProvider());
}
