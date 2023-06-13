import 'package:flutter/material.dart';

class ImThemeController extends ChangeNotifier {
  ThemeData _currentTheme;

  ImThemeController(this._currentTheme);

  ThemeData get theme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
