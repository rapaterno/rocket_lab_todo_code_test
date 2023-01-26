import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';

import 'package:rocket_lab_todo_code_test/data/repository/abstract_todo_repository.dart';
import 'package:rocket_lab_todo_code_test/domain/todo/cubit/todo_cubit.dart';
import 'todo_cubit_test.mocks.dart';

@GenerateMocks([AbstractTodoRepository])
// ignore: long-method
void main() {
  final AbstractTodoRepository mockRepo = MockAbstractTodoRepository();
  group('Todo Cubit Test', () {
    group('When adding a todo', () {
      final todo = Todo(
        id: '1',
        name: 'name',
        isCompleted: false,
        priority: TodoPriority.medium,
      );
      blocTest<TodoCubit, TodoState>(
        'successfully add a todo',
        setUp: (() {
          when(
            mockRepo.createTodo(
              priority: todo.priority,
              name: todo.name,
            ),
          ).thenAnswer((_) => Future.value(todo));
        }),
        build: () => TodoCubit(
          repository: mockRepo,
        ),
        act: (cubit) => cubit.addTodo(name: todo.name, priority: todo.priority),
        expect: () => <TodoState>[
          const TodoState(
            status: TodoStatus.addEditInProgress,
            todos: [],
          ),
          TodoState(
            status: TodoStatus.success,
            todos: [todo],
          ),
        ],
      );
      final initialTodo = Todo(
        id: '0',
        name: 'z',
        isCompleted: false,
        priority: TodoPriority.low,
      );
      final initialState = TodoState(
        todos: [initialTodo],
        sortBy: SortBy.priority,
      );
      blocTest<TodoCubit, TodoState>(
        'successfully add a todo if sort by is set to priority',
        setUp: (() {
          when(
            mockRepo.createTodo(
              priority: todo.priority,
              name: todo.name,
            ),
          ).thenAnswer((_) => Future.value(todo));
        }),
        build: () => TodoCubit(
          repository: mockRepo,
          initialState: initialState,
        ),
        act: (cubit) => cubit.addTodo(name: todo.name, priority: todo.priority),
        expect: () => <TodoState>[
          initialState.copyWith(
            status: TodoStatus.addEditInProgress,
          ),
          initialState
              .copyWith(status: TodoStatus.success, todos: [todo, initialTodo]),
        ],
      );
      blocTest<TodoCubit, TodoState>(
        'fails to add todo',
        setUp: (() {
          when(
            mockRepo.createTodo(
              priority: todo.priority,
              name: todo.name,
            ),
          ).thenThrow('');
        }),
        build: () => TodoCubit(
          repository: mockRepo,
        ),
        act: (cubit) => cubit.addTodo(name: todo.name, priority: todo.priority),
        expect: () => const <TodoState>[
          TodoState(
            status: TodoStatus.addEditInProgress,
            todos: [],
          ),
          TodoState(
            status: TodoStatus.error,
            error: '',
            todos: [],
          ),
        ],
      );
    });
    group('When fetching todos', () {
      blocTest<TodoCubit, TodoState>(
        'Successfully fetch todos',
        setUp: (() {
          when(mockRepo.getTodos(SortBy.createdAt))
              .thenAnswer((_) => Future.value(<Todo>[]));
        }),
        build: () => TodoCubit(repository: mockRepo),
        act: (cubit) => cubit.fetchTodos(),
        expect: () => const <TodoState>[
          TodoState(
            status: TodoStatus.todosLoading,
            todos: [],
          ),
          TodoState(
            status: TodoStatus.todosLoaded,
            todos: [],
          ),
        ],
      );
      blocTest<TodoCubit, TodoState>(
        'Error upon fetching todos',
        setUp: (() {
          when(mockRepo.getTodos(SortBy.createdAt)).thenThrow('');
        }),
        build: () => TodoCubit(repository: mockRepo),
        act: (cubit) => cubit.fetchTodos(),
        expect: () => const <TodoState>[
          TodoState(
            status: TodoStatus.todosLoading,
          ),
          TodoState(
            status: TodoStatus.error,
            error: '',
          ),
        ],
      );
    });
    group('When updating a todo', () {
      final todo = Todo(
        id: '1',
        name: 'name',
        isCompleted: false,
        priority: TodoPriority.medium,
      );
      final updatedTodo = todo.copyWith(isCompleted: true);
      final initialState = TodoState(
        todos: [todo],
      );
      blocTest<TodoCubit, TodoState>(
        'successfully updates a todo',
        setUp: (() {
          when(
            mockRepo.updateTodo(
              id: updatedTodo.id,
              isCompleted: updatedTodo.isCompleted,
              priority: updatedTodo.priority,
              name: updatedTodo.name,
            ),
          ).thenAnswer((_) => Future.value());
        }),
        build: () => TodoCubit(
          repository: mockRepo,
          initialState: initialState,
        ),
        act: (cubit) => cubit.updateTodo(todo: updatedTodo),
        expect: () => <TodoState>[
          TodoState(
            status: TodoStatus.addEditInProgress,
            todos: [todo],
          ),
          TodoState(
            status: TodoStatus.success,
            todos: [updatedTodo],
          ),
        ],
      );
      blocTest<TodoCubit, TodoState>(
        'fails to update todo',
        setUp: (() {
          when(
            mockRepo.updateTodo(
              id: updatedTodo.id,
              isCompleted: updatedTodo.isCompleted,
              priority: updatedTodo.priority,
              name: updatedTodo.name,
            ),
          ).thenThrow('');
        }),
        build: () => TodoCubit(
          repository: mockRepo,
          initialState: initialState,
        ),
        act: (cubit) => cubit.updateTodo(todo: updatedTodo),
        expect: () => <TodoState>[
          TodoState(
            status: TodoStatus.addEditInProgress,
            todos: [todo],
          ),
          TodoState(
            status: TodoStatus.error,
            error: '',
            todos: [todo],
          ),
        ],
      );
    });
    group('When deleting a todo', () {
      final todo = Todo(
        id: '1',
        name: 'name',
        isCompleted: false,
        priority: TodoPriority.medium,
      );
      final initialState = TodoState(
        todos: [todo],
      );
      blocTest<TodoCubit, TodoState>(
        'successfully delete a todo',
        setUp: (() {
          when(
            mockRepo.deleteTodo(
              id: todo.id,
            ),
          ).thenAnswer((_) => Future.value());
        }),
        build: () => TodoCubit(
          repository: mockRepo,
          initialState: initialState,
        ),
        act: (cubit) => cubit.deleteTodo(todo.id),
        expect: () => <TodoState>[
          TodoState(
            status: TodoStatus.deleteInProgress,
            todos: [todo],
          ),
          const TodoState(
            status: TodoStatus.success,
            todos: [],
          ),
        ],
      );
      blocTest<TodoCubit, TodoState>(
        'fails to delete todo',
        setUp: (() {
          when(mockRepo.deleteTodo(id: todo.id)).thenThrow('');
        }),
        build: () => TodoCubit(
          repository: mockRepo,
          initialState: initialState,
        ),
        act: (cubit) => cubit.deleteTodo(todo.id),
        expect: () => <TodoState>[
          TodoState(
            status: TodoStatus.deleteInProgress,
            todos: [todo],
          ),
          TodoState(
            status: TodoStatus.error,
            error: '',
            todos: [todo],
          ),
        ],
      );
    });
  });
}
