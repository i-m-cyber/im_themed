import 'package:flutter/material.dart';

class ImMultiThemeController extends ChangeNotifier {
  Map<String, ThemeData> _themes;
  String _selectedThemeName;

  ImMultiThemeController({
    required Map<String, ThemeData> themes,
    String? selectedThemeName,
  })  : assert(themes.isNotEmpty),
        assert(
            selectedThemeName == null || themes.containsKey(selectedThemeName)),
        _themes = Map.unmodifiable(themes),
        _selectedThemeName = selectedThemeName ?? themes.keys.first;

  ThemeData get theme => _themes[_selectedThemeName]!;

  void addThemes(
    Map<String, ThemeData> themes, {
    String? selectedThemeName,
  }) {
    _themes = Map.unmodifiable({..._themes, ...themes});
    assert(selectedThemeName == null || _themes.containsKey(selectedThemeName));
    _selectedThemeName = selectedThemeName ?? _selectedThemeName;
    notifyListeners();
  }

  void replaceThemes(
    Map<String, ThemeData> themes, {
    String? selectedThemeName,
  }) {
    assert(themes.isNotEmpty);
    assert(selectedThemeName == null || themes.containsKey(selectedThemeName));
    _themes = Map.unmodifiable(themes);
    _selectedThemeName = selectedThemeName ?? themes.keys.first;
    notifyListeners();
  }

  void selectTheme(String themeName) {
    assert(_themes.containsKey(themeName));
    _selectedThemeName = themeName;
    notifyListeners();
  }
}
