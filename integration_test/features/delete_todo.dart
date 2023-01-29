import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';
import 'package:rocket_lab_todo_code_test/main.dart' as app;
import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';

import '../screen_testers/add_edit_screen_tester.dart';
import '../screen_testers/todos_screen_tester.dart';

void main() {
  group('Integration Test - Delete Todos', () {
    tearDown(() {
      DatabaseProvider.deleteTodoDatabase();
      injector.reset();
    });

    testWidgets(
      'Add 2 todos and delete one',
      (tester) async {
        app.main();

        final names = ['Test 1', 'Test 2'];
        final nameOfDeleted = names[0];

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        await todosScreen.verifyScreen();

        for (var name in names) {
          await todosScreen.tapAddButton();

          await addEditScreen.createTodo(name);

          await todosScreen.verifyTodoItemTile(name);
        }

        await todosScreen.tapTodoTile(nameOfDeleted);

        await addEditScreen.deleteTodo();

        await todosScreen.verifyNoTodoTile(nameOfDeleted);
        await todosScreen.verifyTotalAndCompletedTasks(totalTasks: 1);
      },
      tags: ['delete_todos'],
    );
    testWidgets(
      'Add 2 todos and abandon delete',
      (tester) async {
        app.main();

        final names = ['Test 1', 'Test 2'];
        final nameOfDeleted = names[0];

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        await todosScreen.verifyScreen();

        for (var name in names) {
          await todosScreen.tapAddButton();

          await addEditScreen.createTodo(name);

          await todosScreen.verifyTodoItemTile(name);
        }

        await todosScreen.tapTodoTile(nameOfDeleted);

        await addEditScreen.attemptToDelete();

        await todosScreen.verifyTodoItemTile(nameOfDeleted);
        await todosScreen.verifyTotalAndCompletedTasks(totalTasks: 2);
      },
      tags: ['delete_todos'],
    );
  });
}
