import 'todo_localizations.dart';

/// The translations for English (`en`).
class TodoLocalizationsEn extends TodoLocalizations {
  TodoLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get todoList => 'Todo List';

  @override
  String get total => 'Total';

  @override
  String get completed => 'Completed';

  @override
  String get createdAt => 'Created At';

  @override
  String get name => 'Name';

  @override
  String get priority => 'Priority';

  @override
  String get sortBy => 'Sort By';

  @override
  String errorMessage(String errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String get addTodo => 'Add Todo';

  @override
  String get editTodo => 'Edit Todo';

  @override
  String get save => 'Save';

  @override
  String get nameIsEmpty => 'Name is empty';
}
