import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css.dart';
import 'package:im_themed/src/css/parse_css_color.dart';
import 'package:im_themed/third-party/csslib/visitor.dart';
import 'package:tuple/tuple.dart';

import 'angle_term_to_radians.dart';

class _GradientStop {
  _GradientStop({
    required this.color,
    this.position,
  });

  Color color;
  double? position;
}

Tuple2<List<Color>?, List<double>?> _parseGradientStops(List<Expression> exps) {
  double? currentStop;
  Color? currentColor;
  List<_GradientStop> stops = [];

  void addStopIfColorIsAssigned() {
    if (currentColor != null) {
      stops.add(_GradientStop(color: currentColor, position: currentStop));
    }
  }

  for (var exp in exps) {
    // comma operator
    if (exp is OperatorComma) {
      if (currentColor != null) {
        addStopIfColorIsAssigned();
      }
      // we can have comma at the beginning of the list
      // but not two commas with no valid color in between
      else if (currentColor == null && stops.isNotEmpty) {
        throw 'Color stop number ${stops.length + 1} seems to be invalid\n"${exp.span}"\n';
      }
      currentColor = null;
      currentStop = null;
    }
    // percentage term
    else if (exp is PercentageTerm) {
      currentStop = (exp.value as int).toDouble() / 100;
    }
    // expecting color value
    else {
      if (currentColor != null) {
        throw 'Color stop number ${stops.length + 1} seems to have more than one color specified\n"${exp.span}"\n';
      }

      try {
        currentColor = parseCssColorFromExpression(exp);
      } catch (error) {
        throw 'Can not parse color ${exp.span}\n$error';
      }
    }
  }

  addStopIfColorIsAssigned();

  if (stops.isNotEmpty) {
    // normalize stops
    if (stops.length == 1) stops.add(_GradientStop(color: stops.first.color));
    // if not assigned, first stop will be 0%
    stops.first.position ??= 0;
    // if not assigned, last stop will be 100%
    stops.last.position ??= 1;

    // if not assigned, stops with unassigned positions will be
    // linearly distributed in between stops with assigned positions
    var lastAssignedStopIndex = 0;
    for (var current = 1; current < stops.length; current++) {
      if (stops[current].position != null &&
          current - lastAssignedStopIndex > 1) {
        double delta = (stops[current].position! -
                stops[lastAssignedStopIndex].position!) /
            (current - lastAssignedStopIndex);
        for (var i = lastAssignedStopIndex + 1; i < current; i++) {
          stops[i].position = stops[i - 1].position! + delta;
        }
        lastAssignedStopIndex = current;
      }
    }

    stops.sort((s1, s2) => (s1.position! - s2.position!).sign.toInt());

    return Tuple2(
      stops.map((stop) => stop.color).toList().cast<Color>(),
      stops.map((stop) => stop.position).toList().cast<double>(),
    );
  }

  throw 'No color stops specified\n';
}

/// parses CSS gradient, at this point only linear-gradient is supported
/// with first property being angle only (i.e. "to right" is not supported)
Gradient parseCssGradient(String cssGradientValue) {
  Expression? exp = parseCssValue(
    'background',
    cssGradientValue,
  );

  if (exp is FunctionTerm) {
    if (exp.value.toLowerCase() == 'linear-gradient') {
      if (exp.params.expressions.first is! AngleTerm) {
        throw 'linear-gradient first param must be an Angle. Got ${exp.params.expressions.first.runtimeType} instead.\n';
      }

      double angle =
          angleTermToRadians(exp.params.expressions.first as AngleTerm);

      final stops = _parseGradientStops(exp.params.expressions.sublist(1));

      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: stops.item1!,
        stops: stops.item2!,
        tileMode: TileMode.repeated,
        transform: GradientRotation(angle),
      );
    } else {
      throw 'Unknown function ${exp.value.toLowerCase()}';
    }
  }

  throw 'Unknown type ${exp.runtimeType}';
}
