import 'package:flutter/material.dart';

extension ContextUtils on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
