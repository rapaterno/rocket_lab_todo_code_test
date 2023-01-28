import 'package:flutter/material.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/presentation/router/routes.dart';
import 'package:rocket_lab_todo_code_test/presentation/screens/todos_screen/abstract_todos_screen.dart';
import 'package:rocket_lab_todo_code_test/presentation/widgets/todo_item_tile.dart';

class TodosScreen extends AbstractTodosScreen {
  const TodosScreen({super.key});

  @override
  TodosScreenState createState() => TodosScreenState();
}

class TodosScreenState extends AbstractTodosScreenState {
  @override
  Widget buildTodoItemTile(Todo todo) {
    return TodoItemTile(
      todo: todo,
      onIsCompletedChanged: (bool? isCompleted) {
        if (isCompleted != null) {
          onIsCompletedChanged(todo, isCompleted);
        }
      },
      onTap: () {
        onTapTodoTile(todo);
      },
    );
  }

  void onIsCompletedChanged(Todo todo, bool isCompleted) {
    final updatedTodo = todo.copyWith(isCompleted: isCompleted);
    cubit.updateTodo(todo: updatedTodo);
  }

  void onTapTodoTile(Todo todo) {
    Navigator.of(context).pushNamed(
      TodoRoutes.editTodoScreen,
      arguments: todo,
    );
  }
}
