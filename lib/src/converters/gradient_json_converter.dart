import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css_gradient.dart';
import 'package:json_annotation/json_annotation.dart';

var _defaultGradient =
    const LinearGradient(colors: [Colors.white, Colors.black]);

class GradientJsonConverter implements JsonConverter<Gradient, String> {
  const GradientJsonConverter();

  @override
  Gradient fromJson(String json) {
    try {
      return parseCssGradient(json);
    } catch (_) {
      return _defaultGradient;
    }
  }

  @override
  String toJson(Gradient object) => object.toString();
}
