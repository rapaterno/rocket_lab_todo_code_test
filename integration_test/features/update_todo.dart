import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/data/services/database_service.dart';
import 'package:rocket_lab_todo_code_test/main.dart' as app;
import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';

import '../screen_testers/add_edit_screen_tester.dart';
import '../screen_testers/todos_screen_tester.dart';

void main() {
  group('Integration Test - Update Todos', () {
    tearDown(() {
      DatabaseProvider.deleteTodoDatabase();
      injector.reset();
    });

    testWidgets(
      'Mark as complete and see the correct number of completed tasks',
      (tester) async {
        app.main();

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        const name = 'Todo name';

        await todosScreen.verifyScreen();
        await todosScreen.tapAddButton();
        await addEditScreen.createTodo(name);
        await todosScreen.verifyScreen();
        await todosScreen.tapCheckboxOnTile(name);
        await todosScreen.verifyCheckboxValue(name, true);

        await todosScreen.verifyTotalAndCompletedTasks(
          totalTasks: 1,
          completedTasks: 1,
        );
      },
      tags: ['update_todos'],
    );

    testWidgets(
      'Update name and priority of todo',
      (tester) async {
        app.main();

        final todosScreen = TodoScreenTester(tester);
        final addEditScreen = AddEditScreenTester(tester);

        const name = 'Todo name';
        const updatedName = 'Updated name';

        await todosScreen.verifyScreen();
        await todosScreen.tapAddButton();
        await addEditScreen.createTodo(name);
        await todosScreen.verifyScreen();

        await todosScreen.tapTodoTile(name);
        await addEditScreen.editTodo(updatedName, 'low');

        await todosScreen.verifyTodoItemTile(updatedName);

        await todosScreen.verifyTotalAndCompletedTasks(totalTasks: 1);
      },
      tags: ['update_todos'],
    );
  });
}
