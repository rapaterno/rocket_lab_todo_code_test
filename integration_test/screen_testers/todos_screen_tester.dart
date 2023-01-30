import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/data/repository/abstract_todo_repository.dart';
import 'package:rocket_lab_todo_code_test/presentation/widgets/todo_item_tile.dart';
import 'package:rocket_lab_todo_code_test/res/keys.dart';

import '../test_utils.dart';

class TodoScreenTester {
  TodoScreenTester(this.tester);
  final WidgetTester tester;
  static Finder findKey(String key) => find.byKey(Key(key));
  final _addButtonFinder = findKey(TodoKeys.addTodoButton);
  final _screenFinder = findKey(TodoKeys.todosScreen);
  final _sortByDropdownFinder = findKey(TodoKeys.sortByDropdown);
  final _todoItemListFinder = findKey(TodoKeys.todoItemList);
  final _todoItemTilesFinder = find.byType(TodoItemTile);
  final _refreshIndicatorFinder = find.byType(RefreshIndicator);
  final _sortByDropdownButtonFinder = findKey(TodoKeys.sortByDropdown);
  Finder _sortByDropdownMenuItemFiner(String sortBy) =>
      findKey(TodoKeys.sortByDropdownMenuItem(sortBy));
  Finder _completedTasksFinder(int completedTasks) =>
      findKey(TodoKeys.completedTasks(completedTasks));
  Finder _totalTasksFinder(int totalTasks) =>
      findKey(TodoKeys.totalTasks(totalTasks));
  Finder _sortByDropdownMenuItemFinder(String sortBy) =>
      findKey(TodoKeys.sortByDropdownMenuItem(sortBy));
  Finder _todoItemTileFinder(String name) =>
      findKey(TodoKeys.todoItemTile(name));
  Finder _todoItemTileCheckboxFinder(String name) =>
      findKey(TodoKeys.todoItemTileCheckbox(name));

  Future<void> verifyNoTodoTile(String name) async {
    expect(_todoItemTileFinder(name), findsNothing);
  }

  Future<void> switchSortBy(SortBy sortBy) async {
    await tester.tap(_sortByDropdownButtonFinder);
    await tester.pumpAndSettle();
    await tester
        .tap(_sortByDropdownMenuItemFiner(TestUtils.sortByString(sortBy)).last);
    await tester.pumpAndSettle();
  }

  Future<void> verifyTodoItemTile(String name) async {
    await tester.pumpAndSettle();
    expect(_todoItemTileFinder(name), findsOneWidget);
  }

  Future<void> verifyScreen() async {
    await tester.pumpAndSettle();
    expect(_screenFinder, findsOneWidget);
  }

  Future<void> verifyTodoItemList() async {
    await tester.pumpAndSettle();
    expect(_todoItemListFinder, findsOneWidget);
  }

  Future<void> tapAddButton() async {
    await tester.tap(_addButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapTodoTile(String name) async {
    await tester.tap(_todoItemTileFinder(name));
    await tester.pumpAndSettle();
  }

  Future<void> tapCheckboxOnTile(String name) async {
    await tester.tap(_todoItemTileCheckboxFinder(name));
    await tester.pumpAndSettle();
  }

  Future<void> verifyCheckboxValue(String name, bool value) async {
    final checkbox =
        tester.firstWidget(_todoItemTileCheckboxFinder(name)) as Checkbox;
    expect(checkbox.value, value);
  }

  Future<void> verifyOrderOfTodos(List<String> names) async {
    List<TodoItemTile> tiles =
        tester.widgetList<TodoItemTile>(_todoItemTilesFinder).toList();
    expect(names.length, tiles.length);
    for (var i = 0; i < tiles.length; i++) {
      expect(tiles[i].todo.name, names[i]);
    }
  }

  Future<void> pullToRefreshTodoList() async {
    await tester.drag(_refreshIndicatorFinder, const Offset(0.0, 200.0));
    await tester.pumpAndSettle();
  }

  Future<void> verifyTotalAndCompletedTasks({
    int completedTasks = 0,
    int totalTasks = 0,
  }) async {
    await tester.pumpAndSettle();
    expect(_totalTasksFinder(totalTasks), findsOneWidget);
    expect(_completedTasksFinder(completedTasks), findsOneWidget);
  }

  Future<void> changeSortBy(SortBy sortBy) async {
    await tester.tap(_sortByDropdownFinder);
    switch (sortBy) {
      case SortBy.createdAt:
        await tester.tap(_sortByDropdownMenuItemFinder('Created At'));
        break;
      case SortBy.name:
        await tester.tap(_sortByDropdownMenuItemFinder('Name'));
        break;
      case SortBy.priority:
        await tester.tap(_sortByDropdownMenuItemFinder('Priority'));
        break;
    }
  }
}
