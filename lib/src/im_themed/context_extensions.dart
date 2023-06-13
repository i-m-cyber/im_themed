import 'package:flutter/material.dart';
import 'package:im_themed/src/im_themed/im_theme_provider.dart';

extension BuildContextImThemedExtension on BuildContext {
  /// Get current theme
  ThemeData get theme => ImThemeProvider.of(this).theme;

  /// Set current theme
  void setTheme(ThemeData theme) {
    ImThemeProvider.of(this).setTheme(theme);
  }
}
