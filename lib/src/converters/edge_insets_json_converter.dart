import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css_padding_or_margin.dart';
import 'package:json_annotation/json_annotation.dart';

var _defaultEdgeInsets = EdgeInsets.zero;

class EdgeInsetsJsonConverter implements JsonConverter<EdgeInsets, String> {
  const EdgeInsetsJsonConverter();

  @override
  EdgeInsets fromJson(String json) {
    try {
      return parseCssPaddingOrMargin(json);
    } catch (error) {
      return _defaultEdgeInsets;
    }
  }

  @override
  String toJson(EdgeInsets object) => object.toString();
}
