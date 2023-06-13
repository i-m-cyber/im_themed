import 'package:flutter/material.dart';

import 'im_multi_theme_controller.dart';

class ImMultiThemeProvider extends InheritedWidget {
  final ImMultiThemeController controller;

  const ImMultiThemeProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  static ImMultiThemeProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ImMultiThemeProvider>();
  }

  static ImMultiThemeProvider of(BuildContext context) {
    assert(
      context.dependOnInheritedWidgetOfExactType<ImMultiThemeProvider>() !=
          null,
      'No ImMultiThemeProvider found in Widget tree',
    );
    return context.dependOnInheritedWidgetOfExactType<ImMultiThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(ImMultiThemeProvider oldWidget) => true;

  ThemeData get theme => controller.theme;

  void addThemes(
    Map<String, ThemeData> themes, {
    String? selectedThemeName,
  }) =>
      controller.addThemes(themes, selectedThemeName: selectedThemeName);

  void replaceThemes(
    Map<String, ThemeData> themes, {
    String? selectedThemeName,
  }) =>
      controller.replaceThemes(themes, selectedThemeName: selectedThemeName);

  void selectTheme(String themeName) => controller.selectTheme(themeName);
}
