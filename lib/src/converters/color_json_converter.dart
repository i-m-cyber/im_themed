import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css_color.dart';
import 'package:json_annotation/json_annotation.dart';

var _defaultColor = Colors.black;

/// converts string to color and vice versa.
class ColorJsonConverter implements JsonConverter<Color, String> {
  const ColorJsonConverter();

  @override
  Color fromJson(String json) {
    try {
      return parseCssColor(json);
    } catch (_) {
      return _defaultColor;
    }
  }

  @override
  String toJson(Color color) => color.opacity == 1
      ? 'rgb(${color.red}, ${color.green}, ${color.blue})'
      : 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.opacity})';
}
