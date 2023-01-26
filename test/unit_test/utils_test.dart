import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/utils/todo_json_utils.dart';

void main() {
  group(
    'Todo Utils Test',
    (() {
      test('fromTodoPriorityToString Test', () {
        final stringToPriorityMap = {
          TodoPriority.high: 'high',
          TodoPriority.medium: 'medium',
          TodoPriority.low: 'low',
        };
        for (var priority in TodoPriority.values) {
          expect(
            stringToPriorityMap[priority],
            TodoJSONUtils.fromTodoPriorityToString(priority),
          );
        }
      });
      test('fromTodoPriorityToInt Test', () {
        final priorityToIntMap = {
          TodoPriority.high: 0,
          TodoPriority.medium: 1,
          TodoPriority.low: 2,
        };
        for (var priority in TodoPriority.values) {
          expect(
            priorityToIntMap[priority],
            TodoJSONUtils.fromTodoPriorityToInt(priority),
          );
        }
      });
      test('fromIntToTodoPriority Test', () {
        final intToPriorityMap = {
          0: TodoPriority.high,
          1: TodoPriority.medium,
          2: TodoPriority.low,
        };
        for (var num in [0, 1, 2]) {
          expect(
              intToPriorityMap[num], TodoJSONUtils.fromIntToTodoPriority(num));
        }
      });

      group('fromTodoToDatabaseJSON Test', () {
        void testTodoJSONUtils({
          bool isCompleted = true,
          TodoPriority priority = TodoPriority.medium,
        }) {
          final todo = Todo(
            id: '1',
            name: 'todo test name',
            isCompleted: isCompleted,
            priority: priority,
          );
          final actual = {
            'id': todo.id,
            'name': todo.name,
            'is_completed': todo.isCompleted ? 1 : 0,
            'priority': TodoJSONUtils.fromTodoPriorityToInt(todo.priority),
          };

          final json = TodoJSONUtils.fromTodoToDatabaseJSON(todo);

          expect(actual, json);
        }

        test('If todo is complete', () {
          testTodoJSONUtils(isCompleted: true);
        });

        test('If todo is incomplete', () {
          testTodoJSONUtils(isCompleted: false);
        });

        for (var priority in TodoPriority.values) {
          test('If todo is $priority priority', () {
            testTodoJSONUtils(priority: priority);
          });
        }
      });

      group('fromDatabaseJSONToTodo Test', () {
        void testTodoFromJSON({
          bool isCompleted = true,
          TodoPriority priority = TodoPriority.medium,
        }) {
          final actual = Todo(
            id: '1',
            name: 'todo test name',
            isCompleted: isCompleted,
            priority: priority,
          );
          final json = {
            'id': actual.id,
            'name': actual.name,
            'is_completed': actual.isCompleted ? 1 : 0,
            'priority': TodoJSONUtils.fromTodoPriorityToInt(actual.priority),
          };

          final todo = TodoJSONUtils.fromDatabaseJSONToTodo(json);

          expect(actual, todo);
        }

        test('If todo is complete', () {
          testTodoFromJSON(isCompleted: true);
        });

        test('If todo is incomplete', () {
          testTodoFromJSON(isCompleted: false);
        });

        for (var priority in TodoPriority.values) {
          test('If todo is $priority priority', () {
            testTodoFromJSON(priority: priority);
          });
        }
      });
    }),
  );
}
