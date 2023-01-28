import 'package:flutter/material.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/presentation/widgets/todo_priority_icon.dart';
import 'package:rocket_lab_todo_code_test/res/keys.dart';

class TodoItemTile extends StatelessWidget {
  const TodoItemTile({
    super.key,
    required this.todo,
    required this.onIsCompletedChanged,
    required this.onTap,
  });

  final Todo todo;
  final dynamic Function(bool?) onIsCompletedChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(TodoKeys.todoItemTile(todo.name)),
      trailing: _buildCheckbox(),
      leading: TodoPriorityIcon(priority: todo.priority),
      title: Text(todo.name),
      onTap: onTap,
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(
      key: Key(TodoKeys.todoItemTileCheckbox(todo.name)),
      value: todo.isCompleted,
      onChanged: onIsCompletedChanged,
    );
  }
}
