import 'package:flutter/widgets.dart';
import 'package:rocket_lab_todo_code_test/l10n/generated/todo_localizations.dart';

extension Localization on BuildContext {
  TodoLocalizations? get l10n => TodoLocalizations.of(this);
}
