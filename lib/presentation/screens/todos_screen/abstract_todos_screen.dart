import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/repository/abstract_todo_repository.dart';
import 'package:rocket_lab_todo_code_test/domain/todo/cubit/todo_cubit.dart';
import 'package:rocket_lab_todo_code_test/l10n/generated/todo_localizations.dart';
import 'package:rocket_lab_todo_code_test/presentation/router/routes.dart';
import 'package:rocket_lab_todo_code_test/res/keys.dart';

abstract class AbstractTodosScreen extends StatefulWidget {
  const AbstractTodosScreen({super.key});
}

abstract class AbstractTodosScreenState extends State<AbstractTodosScreen> {
  late TodoCubit cubit;
  late TodoLocalizations localizations;
  Completer? completer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = TodoLocalizations.of(context)!;
    cubit = context.read<TodoCubit>();
    cubit.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key(TodoKeys.todosScreen),
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: _buildRefreshIndicator(),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text(localizations.todoList),
      actions: [
        IconButton(
          key: Key(TodoKeys.addTodoButton),
          onPressed: () =>
              Navigator.of(context).pushNamed(TodoRoutes.addTodoScreen),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Padding buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BlocBuilder<TodoCubit, TodoState>(
        buildWhen: (previous, current) =>
            previous.todos != current.todos ||
            current.status == TodoStatus.todosLoading,
        builder: (context, state) {
          if (state.status == TodoStatus.todosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final todos = state.todos;
            final numOfCompletedTodos = todos.fold<int>(
              0,
              (prev, todo) => todo.isCompleted ? prev + 1 : prev,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildStatHeader(
                  localizations.total,
                  todos.length,
                  Key(TodoKeys.totalTasks(todos.length)),
                ),
                const SizedBox(width: 16),
                buildStatHeader(
                  localizations.completed,
                  numOfCompletedTodos,
                  Key(TodoKeys.completedTasks(numOfCompletedTodos)),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildStatHeader(String title, int statisticValue, [Key? key]) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Text(
            key: key,
            statisticValue.toStringAsFixed(0),
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildRefreshIndicator() {
    return BlocListener<TodoCubit, TodoState>(
      listener: (context, state) {
        /// If the status is Todos Loaded or Error, the listener will complete the `completer` object.
        /// To end the refresh of the refresh indicator
        if (state.status == TodoStatus.error) {
          completer?.complete();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.errorMessage(state.error)),
            ),
          );
        } else if (state.status == TodoStatus.todosLoaded) {
          if (!(completer?.isCompleted ?? true)) {
            completer?.complete();
          }
        }
      },
      child: buildBody(),
    );
  }

  Widget buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        completer = Completer<void>();
        cubit.fetchTodos();
        return completer?.future;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: buildHeader(),
          ),
          SliverToBoxAdapter(
            child: buildSortBy(),
          ),
          buildTodoList(),
        ],
      ),
    );
  }

  BlocBuilder<TodoCubit, TodoState> buildTodoList() {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        switch (state.status) {
          case TodoStatus.initial:
          case TodoStatus.todosLoading:
          case TodoStatus.addEditInProgress:
          case TodoStatus.deleteInProgress:
            return SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(
                  key: Key(TodoKeys.progressIndicator),
                ),
              ),
            );

          default:
            final todos = state.todos;
            return SliverList(
              key: Key(TodoKeys.todoItemList),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    buildTodoItemTile(todos[index]),
                childCount: todos.length,
              ),
            );
        }
      },
    );
  }

  Padding buildSortBy() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${localizations.sortBy}:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          buildSortByDropdown(),
        ],
      ),
    );
  }

  Widget buildSortByDropdown() {
    return BlocBuilder<TodoCubit, TodoState>(
      buildWhen: (prev, current) => prev.sortBy != current.sortBy,
      builder: (context, state) {
        return DropdownButton(
          key: Key(TodoKeys.sortByDropdown),
          icon: const Icon(Icons.sort),
          value: state.sortBy,
          isDense: true,
          items: SortBy.values
              .map(
                (e) => DropdownMenuItem<SortBy>(
                  value: e,
                  child: Text(
                    key: sortByToKey(e),
                    sortByToString(e),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            cubit.fetchTodos(sortBy: value);
          },
        );
      },
    );
  }

  String sortByToString(SortBy sortBy) {
    switch (sortBy) {
      case SortBy.createdAt:
        return localizations.createdAt;
      case SortBy.priority:
        return localizations.priority;
      case SortBy.name:
        return localizations.name;
    }
  }

  Key sortByToKey(SortBy sortBy) {
    String keyText;
    switch (sortBy) {
      case SortBy.createdAt:
        keyText = 'created at';
        break;
      case SortBy.priority:
        keyText = 'priority';
        break;
      case SortBy.name:
        keyText = 'name';
    }

    return Key(TodoKeys.sortByDropdownMenuItem(keyText));
  }

  Widget buildTodoItemTile(Todo todo);
}
