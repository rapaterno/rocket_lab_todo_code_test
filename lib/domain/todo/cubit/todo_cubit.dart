import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/repository/abstract_todo_repository.dart';

part 'todo_state.dart';
part 'todo_cubit.freezed.dart';

class TodoCubit extends Cubit<TodoState> {
  AbstractTodoRepository repository;
  TodoCubit({
    required this.repository,
    TodoState initialState = const TodoState(),
  }) : super(initialState);

  // This function sorts a list of todos based on a selected sort criteria
  // for when todos are added or updated
  List<Todo> sortTodoList(List<Todo> todos) {
    switch (state.sortBy) {
      // If sortBy is set to SortBy.createdAt, return the original todo list
      case SortBy.createdAt:
        return todos;
      case SortBy.name:
        return todos..sort((a, b) => a.name.compareTo(b.name));
      case SortBy.priority:
        return todos
          ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
    }
  }

  void addTodo({required String name, required TodoPriority priority}) async {
    emit(state.copyWith(status: TodoStatus.addEditInProgress));
    try {
      final todo = await repository.createTodo(name: name, priority: priority);

      emit(
        state.copyWith(
          status: TodoStatus.success,
          todos: sortTodoList(List.of(state.todos)..add(todo)),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error, error: e.toString()));
    }
  }

  void fetchTodos({SortBy? sortBy}) async {
    final sortByToUse = sortBy ?? state.sortBy;
    emit(state.copyWith(status: TodoStatus.todosLoading, sortBy: sortByToUse));
    try {
      final todos = await repository.getTodos(sortByToUse);
      emit(state.copyWith(status: TodoStatus.todosLoaded, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error, error: e.toString()));
    }
  }

  void updateTodo({required Todo todo}) async {
    emit(state.copyWith(status: TodoStatus.addEditInProgress));
    try {
      await repository.updateTodo(
        id: todo.id,
        isCompleted: todo.isCompleted,
        priority: todo.priority,
        name: todo.name,
      );
      List<Todo> todos = List.of(state.todos);
      final index = todos.indexWhere((item) => todo.id == item.id);
      todos[index] = todo;

      emit(
        state.copyWith(todos: sortTodoList(todos), status: TodoStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error, error: e.toString()));
    }
  }

  void deleteTodo(String id) async {
    emit(state.copyWith(status: TodoStatus.deleteInProgress));
    try {
      await repository.deleteTodo(id: id);
      List<Todo> todos = List.of(state.todos);
      todos.removeWhere((todo) => todo.id == id);
      emit(state.copyWith(status: TodoStatus.success, todos: todos));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error, error: e.toString()));
    }
  }
}
