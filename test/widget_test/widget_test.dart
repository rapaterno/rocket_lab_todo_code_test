import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/presentation/widgets/todo_item_tile.dart';
import 'package:rocket_lab_todo_code_test/presentation/widgets/todo_priority_icon.dart';
import 'package:rocket_lab_todo_code_test/res/colors.dart';

void main() {
  group('Test Todo Item Tile', () {
    testWidgets('Displays todo item name and priority icon',
        (WidgetTester tester) async {
      final todo = Todo(
        id: '1',
        name: 'Test Todo',
        priority: TodoPriority.high,
        isCompleted: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItemTile(
              todo: todo,
              onIsCompletedChanged: (_) {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(todo.name), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(TodoPriorityIcon), findsOneWidget);
    });

    testWidgets('Calls onIsCompletedChanged when checkbox is changed',
        (WidgetTester tester) async {
      final todo = Todo(
        id: '1',
        isCompleted: false,
        name: 'Test Todo',
        priority: TodoPriority.high,
      );
      var isChecked = false;
      void onIsCompletedChanged(value) {
        isChecked = value;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItemTile(
              todo: todo,
              onIsCompletedChanged: onIsCompletedChanged,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(isChecked, isTrue);
    });

    testWidgets('Calls onTap when list tile is tapped',
        (WidgetTester tester) async {
      final todo = Todo(
        id: '1',
        isCompleted: false,
        name: 'Test Todo',
        priority: TodoPriority.high,
      );
      var isTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItemTile(
              todo: todo,
              onIsCompletedChanged: (_) {},
              onTap: () {
                isTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(isTapped, isTrue);
    });
  });

  group('TodoPriorityIcon', () {
    testWidgets(
        'High priority Icon shows arrow up icon with Bright Orange color',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TodoPriorityIcon(priority: TodoPriority.high)),
        ),
      );

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget(iconFinder) as Icon;
      expect(icon.icon, Icons.keyboard_arrow_up_rounded);
      expect(icon.color, TodoColors.brightOrange);
    });

    testWidgets(
        'Medium priority Icon should show remove icon with Golden Yellow color',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TodoPriorityIcon(priority: TodoPriority.medium)),
        ),
      );

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget(iconFinder) as Icon;
      expect(icon.icon, Icons.remove_rounded);
      expect(icon.color, TodoColors.goldenYellow);
    });

    testWidgets(
        'Low priority icon should show arrow down icon with Electric Blue color',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TodoPriorityIcon(priority: TodoPriority.low)),
        ),
      );

      final iconFinder = find.byType(Icon);
      expect(iconFinder, findsOneWidget);

      final icon = tester.widget(iconFinder) as Icon;
      expect(icon.icon, Icons.keyboard_arrow_down_rounded);
      expect(icon.color, TodoColors.electricBlue);
    });
  });
}
