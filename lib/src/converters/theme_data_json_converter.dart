import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css_color.dart';
import 'package:json_annotation/json_annotation.dart';

/// converts Map to ThemeData and vice versa.
class ThemeDataJsonConverter implements JsonConverter<ThemeData, Map> {
  const ThemeDataJsonConverter();

  @override
  ThemeData fromJson(Map json) {
    if (!{'dark', 'light', null}.contains(json['brightness'])) {
      throw 'brightness property must be "dark" or "light" or not set';
    }

    final primaryColor = json['primaryColor'] != null
        ? parseCssColor(json['primaryColor'])
        : null;

    return ThemeData(
      useMaterial3: json['useMaterial3'] ?? false,
      brightness:
          json['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      primarySwatch: primaryColor == null
          ? null
          : MaterialColor(
              primaryColor.value,
              <int, Color>{
                50: primaryColor.withOpacity(0.1),
                100: primaryColor.withOpacity(0.2),
                200: primaryColor.withOpacity(0.3),
                300: primaryColor.withOpacity(0.4),
                400: primaryColor.withOpacity(0.5),
                500: primaryColor.withOpacity(0.6),
                600: primaryColor.withOpacity(0.7),
                700: primaryColor.withOpacity(0.8),
                800: primaryColor.withOpacity(0.9),
                900: primaryColor.withOpacity(1.0),
              },
            ),
    );
  }

  @override
  Map toJson(ThemeData themeData) {
    final primaryColor = themeData.primaryColor;
    final primaryColorString = primaryColor.opacity == 1
        ? 'rgb(${primaryColor.red},${primaryColor.green},${primaryColor.blue})'
        : 'rgba(${primaryColor.red},${primaryColor.green},${primaryColor.blue},${primaryColor.opacity}})';

    return {
      'useMaterial3': themeData.useMaterial3,
      'brightness': themeData.brightness == Brightness.dark ? 'dark' : 'light',
      'primaryColor': primaryColorString,
    };
  }
}

extension ThemeDataJsonConverterExtension on ThemeData {
  /// converts Map to ThemeData.
  static fromJson(Map json) => const ThemeDataJsonConverter().fromJson(json);

  /// converts ThemeData to Map.
  Map toJson() => const ThemeDataJsonConverter().toJson(this);
}
