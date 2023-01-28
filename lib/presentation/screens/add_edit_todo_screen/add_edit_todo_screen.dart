import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rocket_lab_todo_code_test/data/model/todo/todo.dart';
import 'package:rocket_lab_todo_code_test/data/utils/todo_json_utils.dart';
import 'package:rocket_lab_todo_code_test/domain/todo/cubit/todo_cubit.dart';
import 'package:rocket_lab_todo_code_test/l10n/generated/todo_localizations.dart';
import 'package:rocket_lab_todo_code_test/presentation/widgets/todo_priority_icon.dart';
import 'package:rocket_lab_todo_code_test/res/keys.dart';

class AddEditTodoScreen extends StatefulWidget {
  const AddEditTodoScreen({super.key});

  @override
  AddEditTodoScreenState createState() => AddEditTodoScreenState();
}

class AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _key = GlobalKey<FormState>();
  Todo? todo;

  late String todoName;
  late TodoPriority priority;

  bool get isEdit => todo != null;

  late TodoCubit cubit;
  late TodoLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = TodoLocalizations.of(context)!;
    cubit = context.read<TodoCubit>();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      todo = args as Todo;
    }

    priority = todo?.priority ?? TodoPriority.medium;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key(isEdit ? TodoKeys.editScreen : TodoKeys.addScreen),
      appBar: AppBar(
        title: Text(isEdit ? localizations.editTodo : localizations.addTodo),
        actions: [
          if (isEdit)
            IconButton(
              key: Key(TodoKeys.deleteButton),
              onPressed: () async {
                await showDeleteDialog(context);
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              buildNameField(),
              const SizedBox(height: 16),
              buildPriorityField(),
              const SizedBox(height: 32),
              buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteTodo),
        content: Text(localizations.areYouSureYouWantToDelete),
        actions: [
          TextButton(
            key: Key(TodoKeys.cancelButton),
            onPressed: () => Navigator.of(context).pop<bool>(false),
            child: Text(localizations.cancel),
          ),
          TextButton(
            key: Key(TodoKeys.confirmButton),
            onPressed: () {
              cubit.deleteTodo(todo!.id);
              Navigator.pop(context);
            },
            child: Text(localizations.yes),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();

    bool isValid = _key.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _key.currentState?.save();
    isEdit
        ? cubit.updateTodo(
            todo: todo!.copyWith(name: todoName, priority: priority),
          )
        : cubit.addTodo(name: todoName, priority: priority);
  }

  Widget buildSaveButton() {
    return BlocConsumer<TodoCubit, TodoState>(
      listenWhen: (previous, current) {
        return previous.status != current.status &&
            current.status == TodoStatus.success;
      },
      listener: (context, state) {
        if (state.status == TodoStatus.success) Navigator.pop(context);
      },
      builder: (context, state) {
        Function()? onPressed;
        Widget child;
        if (state.status == TodoStatus.addEditInProgress) {
          child = const SizedBox.square(
            dimension: 10,
            child: CircularProgressIndicator(),
          );
        } else {
          child = Text(localizations.save);
          onPressed = () {
            _submitForm();
          };
        }
        return ElevatedButton(
          key: Key(TodoKeys.saveButton),
          onPressed: onPressed,
          child: child,
        );
      },
    );
  }

  Widget buildNameField() {
    return TextFormField(
      key: Key(TodoKeys.nameTextField),
      initialValue: todo?.name ?? '',
      cursorColor: Colors.indigo,
      onSaved: (value) {
        todoName = value ?? '';
      },
      validator: (value) {
        if (value != null && value.isEmpty) {
          return localizations.nameIsEmpty;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: localizations.name,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Widget buildPriorityField() {
    return FormField<TodoPriority>(
      builder: (FormFieldState<TodoPriority> state) {
        return InputDecorator(
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
          isEmpty: false,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TodoPriority>(
              key: Key(TodoKeys.priorityDropdownField),
              value: priority,
              isDense: true,
              onChanged: (TodoPriority? newValue) {
                if (newValue != null) {
                  setState(() {
                    priority = newValue;
                    state.didChange(newValue);
                  });
                }
              },
              items:
                  TodoPriority.values.map(buildPriorityDropdownItem).toList(),
            ),
          ),
        );
      },
    );
  }

  DropdownMenuItem<TodoPriority> buildPriorityDropdownItem(TodoPriority value) {
    final priorityString = TodoJSONUtils.fromTodoPriorityToString(value);
    return DropdownMenuItem<TodoPriority>(
      value: value,
      child: Row(
        children: [
          TodoPriorityIcon(priority: value),
          const SizedBox(
            width: 8,
          ),
          Text(
            key: Key(TodoKeys.priorityDropdownMenuItem(priorityString)),
            priorityString,
          ),
        ],
      ),
    );
  }
}
