import 'package:flutter/material.dart';
import 'package:rocket_lab_todo_code_test/presentation/router/routes.dart';
import 'package:rocket_lab_todo_code_test/presentation/screens/add_edit_todo_screen/add_edit_todo_screen.dart';
import 'package:rocket_lab_todo_code_test/presentation/screens/todos_screen/todos_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case TodoRoutes.todosScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TodosScreen(),
        );
      case TodoRoutes.addTodoScreen:
      case TodoRoutes.editTodoScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AddEditTodoScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TodosScreen(),
        );
    }
  }
}
