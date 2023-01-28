import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/res/keys.dart';

class AddEditScreenTester {
  AddEditScreenTester(this.tester);
  final WidgetTester tester;
  static Finder findKey(String key) => find.byKey(Key(key));
  final deleteButtonFinder = findKey(TodoKeys.deleteButton);
  final confirmButtonFinder = findKey(TodoKeys.confirmButton);
  final cancelButtonFinder = findKey(TodoKeys.cancelButton);
  final saveButtonFinder = findKey(TodoKeys.saveButton);
  final addScreenFinder = findKey(TodoKeys.addScreen);
  final editScreenFinder = findKey(TodoKeys.editScreen);
  final nameTextFieldFinder = findKey(TodoKeys.nameTextField);
  final priorityDropdownField = findKey(TodoKeys.priorityDropdownField);
  final nameIsEmptyFinder = find.text(TodoKeys.nameIsEmpty);

  Finder priorityDropdownMenuItem(String priority) =>
      findKey(TodoKeys.priorityDropdownMenuItem(priority));

  Future<void> goBackAPage() async {
    await tester.pageBack();
    await tester.pumpAndSettle();
  }

  Future<void> tapConfirmButton() async {
    await tester.tap(confirmButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> saveTodo() async {
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> enterName(String name) async {
    await tester.enterText(nameTextFieldFinder, name);
  }

  Future<void> changePriority(String priority) async {
    await tester.tap(priorityDropdownField);
    await tester.pumpAndSettle();
    await tester.tap(priorityDropdownMenuItem(priority).last);
    await tester.pumpAndSettle();
  }

  Future<void> deleteTodo() async {
    await tester.tap(deleteButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(confirmButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> attemptToDelete() async {
    await tester.tap(deleteButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(cancelButtonFinder);
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(confirmButtonFinder);
  }

  Future<void> verifyErrorOnNameField() async {
    await tester.pumpAndSettle();
    expect(nameIsEmptyFinder, findsOneWidget);
  }

  Future<void> editTodo(String name, String priority) async {
    await enterName(name);
    await changePriority(priority);
    await saveTodo();
  }

  Future<void> createTodo(String name, [String? priority]) async {
    await enterName(name);
    if (priority != null) {
      await changePriority(priority);
    }

    await saveTodo();
  }
}
