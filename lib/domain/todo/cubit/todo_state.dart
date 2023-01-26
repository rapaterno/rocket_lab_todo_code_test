part of 'todo_cubit.dart';

enum TodoStatus {
  initial,
  todosLoading,
  todosLoaded,
  addEditInProgress,
  deleteInProgress,
  success,
  error,
}

@freezed
class TodoState with _$TodoState {
  const factory TodoState({
    @Default(TodoStatus.initial) TodoStatus status,
    @Default('') String error,
    @Default([]) List<Todo> todos,
    @Default(SortBy.createdAt) SortBy sortBy,
  }) = _TodoState;
}
