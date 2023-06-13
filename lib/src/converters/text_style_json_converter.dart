import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css_font.dart';
import 'package:json_annotation/json_annotation.dart';

const _defaultTextStyle = TextStyle();

class TextStyleJsonConverter implements JsonConverter<TextStyle, String> {
  const TextStyleJsonConverter();

  @override
  TextStyle fromJson(String json) {
    try {
      return parseCssFont(json);
    } catch (_) {
      return _defaultTextStyle;
    }
  }

  @override
  String toJson(TextStyle object) => object.toString();
}
