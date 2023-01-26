import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

enum TodoPriority { high, medium, low }

@freezed
class Todo with _$Todo {
  factory Todo({
    required String id,
    required String name,
    required bool isCompleted,
    required TodoPriority priority,
  }) = _Todo;
}
