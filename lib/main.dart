import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rocket_lab_todo_code_test/presentation/app/app_bloc_observer.dart';
import 'package:rocket_lab_todo_code_test/presentation/injector/injector.dart';

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
    return MaterialApp(
      title: 'Rocket Lab Todo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('en'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
