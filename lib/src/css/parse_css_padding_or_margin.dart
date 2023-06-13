import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css_length.dart';

/// parses CSS padding or margin value which can have 1 to 4
/// CssLength properties separated by space.
/// Supported values are only one supported
/// by parseCssLength function in ./parse_css_length.dart file
/// For documentation on CSS padding and margin properties visit:
/// https://developer.mozilla.org/en-US/docs/Web/CSS/padding
EdgeInsets parseCssPaddingOrMargin(String paddingOrMargin) {
  final values = paddingOrMargin
      .split(RegExp(r'\s'))
      .where((s) => s.isNotEmpty)
      .map((s) => parseCssLength(s))
      .toList();

  if (values.isNotEmpty && values.length <= 4) {
    switch (values.length) {
      case 1:
        return EdgeInsets.all(values[0]);
      case 2:
        return EdgeInsets.symmetric(
          vertical: values[0],
          horizontal: values[1],
        );
      case 3:
        return EdgeInsets.only(
          top: values[0],
          right: values[1],
          bottom: values[2],
          left: values[1],
        );
      default:
        return EdgeInsets.only(
          top: values[0],
          right: values[1],
          bottom: values[2],
          left: values[3],
        );
    }
  }

  throw 'Can not parse paddingOrMargin "$paddingOrMargin"';
}
