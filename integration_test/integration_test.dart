import 'package:integration_test/integration_test.dart';
import 'features/add_todo.dart' as add_features;
import 'features/delete_todo.dart' as delete_features;
import 'features/update_todo.dart' as update_features;
import 'features/view_todos.dart' as view_features;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  add_features.main();
  delete_features.main();
  update_features.main();
  view_features.main();
}
