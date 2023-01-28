import 'package:flutter/material.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/res/colors.dart';

class TodoPriorityIcon extends StatelessWidget {
  const TodoPriorityIcon({super.key, required this.priority});

  final TodoPriority priority;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color color;

    switch (priority) {
      case TodoPriority.high:
        icon = Icons.keyboard_arrow_up_rounded;
        color = TodoColors.brightOrange;
        break;
      case TodoPriority.medium:
        icon = Icons.remove_rounded;
        color = TodoColors.goldenYellow;
        break;
      case TodoPriority.low:
        icon = Icons.keyboard_arrow_down_rounded;
        color = TodoColors.electricBlue;
        break;
    }
    return Icon(
      icon,
      color: color,
    );
  }
}
