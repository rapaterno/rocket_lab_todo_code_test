import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rocket_lab_todo_code_test/domain/todo/cubit/todo_cubit.dart';
import 'package:rocket_lab_todo_code_test/l10n/generated/todo_localizations.dart';
import 'package:rocket_lab_todo_code_test/l10n/support_locale.dart';
import 'package:rocket_lab_todo_code_test/presentation/app/app_bloc_observer.dart';
import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';
import 'package:rocket_lab_todo_code_test/presentation/router/route_generator.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  setupInjectors();
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider.value(
      value: injector<TodoCubit>(),
      child: MaterialApp(
        title: 'Rocket Lab Todo',
        localizationsDelegates: const [
          TodoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
        supportedLocales: L10n.support,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
