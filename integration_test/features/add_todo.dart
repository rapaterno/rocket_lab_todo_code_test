import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';
import 'package:rocket_lab_todo_code_test/main.dart' as app;
import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';

import '../screen_testers/add_edit_screen_tester.dart';
import '../screen_testers/todos_screen_tester.dart';

void main() {
  group('Integration Test - Adds Todos', () {
    tearDown(() {
      DatabaseProvider.deleteTodoDatabase();
      injector.reset();
    });

    testWidgets(
      'Abandon creating a todo and see no todo created',
      (tester) async {
        app.main();

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        await todosScreen.verifyScreen();

        await todosScreen.tapAddButton();

        await addEditScreen.goBackAPage();
        await addEditScreen.tapConfirmButton();

        await todosScreen.verifyTotalAndCompletedTasks();
      },
      tags: ['add_todos'],
    );
    testWidgets(
      'Expect error on add todo screen if name is empty',
      (tester) async {
        app.main();

        const name = 'Test 1';

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        await todosScreen.verifyScreen();

        await todosScreen.tapAddButton();

        await addEditScreen.saveTodo();
        await addEditScreen.verifyErrorOnNameField();
        await addEditScreen.createTodo(name);

        await todosScreen.verifyTotalAndCompletedTasks(totalTasks: 1);
      },
      tags: ['add_todos'],
    );

    testWidgets(
      'Add 3 todos and verify the total number of tasks',
      (tester) async {
        app.main();

        final names = ['Test 1', 'Test 2', 'Test 3'];

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        await todosScreen.verifyScreen();

        for (var name in names) {
          await todosScreen.tapAddButton();

          await addEditScreen.createTodo(name);

          await todosScreen.verifyTodoItemTile(name);
        }
        await todosScreen.verifyTotalAndCompletedTasks(
          totalTasks: names.length,
        );
      },
      tags: ['add_todos'],
    );
  });
}
