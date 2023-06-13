import 'package:flutter/material.dart';

import 'im_multi_theme_provider.dart';

extension BuildContextImMultiThemedExtension on BuildContext {
  /// Get current theme
  ThemeData get theme => ImMultiThemeProvider.of(this).theme;

  /// Add themes to existing map of themes
  void addThemes(
    Map<String, ThemeData> themes, {
    String? selectedThemeName,
  }) =>
      ImMultiThemeProvider.of(this)
          .addThemes(themes, selectedThemeName: selectedThemeName);

  /// Replace existing map of themes
  void replaceThemes({
    required Map<String, ThemeData> themes,
    String? selectedThemeName,
  }) =>
      ImMultiThemeProvider.of(this)
          .replaceThemes(themes, selectedThemeName: selectedThemeName);

  /// Select theme by name
  void selectTheme(String themeName) =>
      ImMultiThemeProvider.of(this).selectTheme(themeName);
}
