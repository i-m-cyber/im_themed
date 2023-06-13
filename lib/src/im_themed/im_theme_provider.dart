import 'package:flutter/material.dart';
import 'package:im_themed/src/im_themed/im_theme_controller.dart';

class ImThemeProvider extends InheritedWidget {
  final ImThemeController controller;

  const ImThemeProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  static ImThemeProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ImThemeProvider>();
  }

  static ImThemeProvider of(BuildContext context) {
    assert(
      context.dependOnInheritedWidgetOfExactType<ImThemeProvider>() != null,
      'No ImThemeProvider found in Widget tree',
    );
    return context.dependOnInheritedWidgetOfExactType<ImThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(ImThemeProvider oldWidget) => true;

  ThemeData get theme => controller.theme;

  void setTheme(ThemeData theme) => controller.setTheme(theme);
}
