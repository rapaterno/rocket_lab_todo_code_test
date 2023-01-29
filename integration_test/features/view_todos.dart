import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';
import 'package:rocket_lab_todo_code_test/main.dart' as app;
import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';

import '../screen_testers/add_edit_screen_tester.dart';
import '../screen_testers/todos_screen_tester.dart';

class TodoTest {
  const TodoTest(this.name, this.priority);
  final String name;
  final String priority;
}

void main() {
  group('Integration Test - View Todos', () {
    tearDown(() {
      DatabaseProvider.deleteTodoDatabase();
      injector.reset();
    });

    testWidgets(
      'Verify sort by todos is in proper order',
      (tester) async {
        app.main();

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        const todos = [
          TodoTest('name 1', 'high'),
          TodoTest('name 3', 'low'),
          TodoTest('name 2', 'medium'),
        ];

        await todosScreen.verifyScreen();
        await todosScreen.switchSortBy('priority');

        for (var todo in todos) {
          await todosScreen.tapAddButton();

          await addEditScreen.createTodo(todo.name, todo.priority);
        }

        await todosScreen
            .verifyOrderOfTodos([todos[0].name, todos[2].name, todos[1].name]);

        for (var todo in todos) {
          await todosScreen.verifyTodoItemTile(todo.name);
        }
      },
      tags: ['view_todos'],
    );
    testWidgets(
      'Pull down to refresh does not cause any errors and still shows the same todos',
      (tester) async {
        app.main();
        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);
        final names = ['Test 1', 'Test 2', 'Test 3'];

        await todosScreen.verifyScreen();

        for (var name in names) {
          await todosScreen.tapAddButton();

          await addEditScreen.createTodo(name);
        }

        await todosScreen.pullToRefreshTodoList();

        for (var name in names) {
          await todosScreen.verifyTodoItemTile(name);
        }
      },
      tags: ['view_todos'],
    );
  });
}
