import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css.dart';
import 'package:im_themed/third-party/csslib/visitor.dart';

/// filters List<Expression> by keeping
/// only NumberTerm and PercentageTerm values
/// and extracts values from those 2 types as int or double
/// where PercentageTerm is converted to double so 100% = 1.0
List<dynamic> _extractNumbers(List<Expression> expressions) {
  return expressions
      .where((exp) => exp is NumberTerm || exp is PercentageTerm)
      .map((exp) => exp is PercentageTerm
          ? exp.value.toDouble() / 100
          : exp is NumberTerm
              ? exp.value
              : double.nan)
      .toList();
}

/// filters List<Expression> by keeping
/// only NumberTerm and PercentageTerm values
/// and converts all values to double
/// where PercentageTerm is converted to double so 100% = 1.0
List<double> _extractNumbersAsDouble(
  List<Expression> expressions, {
  double hundredPercentsEqualsTo = 1.0,
  double fallbackValue = double.nan,
}) {
  return expressions
      .where((exp) => exp is NumberTerm || exp is PercentageTerm)
      .map((exp) => exp is PercentageTerm
          ? exp.value.toDouble() * hundredPercentsEqualsTo / 100
          : exp is NumberTerm && exp.value is int
              ? exp.value.toDouble()
              : exp is NumberTerm && exp.value is double
                  ? exp.value
                  : fallbackValue)
      .toList()
      .cast<double>();
}

// i.e. 0x05 becomes 0x55
// i.e. 0x17 becomes 0x77
// i.e. 0xA3 becomes 0x33
int _bit4to8(int i) {
  return ((i & 0xF) << 4 | i & 0xF);
}

/// returns Color from css color expression\
/// supported values:\
/// red, blue, 0xFFF, 0xCDCDCD, rgb(0,255,0), rgba(255,255,255,0.5),
/// hsl(89, 43%, 51%), hsla(89, 43%, 51%, 0.9)
Color parseCssColorFromExpression(Expression? exp) {
  // rgb() or rgba()
  if (exp is FunctionTerm) {
    // rgb color
    if (exp.value.toLowerCase() == 'rgb') {
      var values = _extractNumbers(exp.params.expressions);
      while (values.length < 3) {
        values.add(0);
      }

      return Color.fromRGBO(
        values[0] is int ? values[0] : (values[0] as double).toInt(),
        values[1] is int ? values[1] : (values[1] as double).toInt(),
        values[2] is int ? values[2] : (values[2] as double).toInt(),
        1,
      );
    }
    // rgba color
    else if (exp.value.toLowerCase() == 'rgba') {
      var values = _extractNumbers(exp.params.expressions);
      while (values.length < 3) {
        values.add(0);
      }
      if (values.length < 4) values.add(1.0);

      return Color.fromRGBO(
        values[0] is int ? values[0] : (values[0] as double).toInt(),
        values[1] is int ? values[1] : (values[1] as double).toInt(),
        values[2] is int ? values[2] : (values[2] as double).toInt(),
        values[3] is int ? values[3].toDouble() : values[3],
      );
    }
    // hsl color
    else if (exp.value.toLowerCase() == 'hsl') {
      var values = _extractNumbersAsDouble(exp.params.expressions);
      while (values.length < 3) {
        values.add(0);
      }

      return HSLColor.fromAHSL(
        1.0,
        values[0],
        values[1],
        values[2],
      ).toColor();
    }
    // hsla color
    else if (exp.value.toLowerCase() == 'hsla') {
      var values = _extractNumbersAsDouble(exp.params.expressions);
      while (values.length < 3) {
        values.add(0);
      }
      if (values.length < 4) values.add(1.0);

      return HSLColor.fromAHSL(
        values[3],
        values[0],
        values[1],
        values[2],
      ).toColor();
    } else {
      throw 'Unknown function ${exp.value.toLowerCase()}';
    }
  }
  // HEX: #fff or #ffffff
  else if (exp is HexColorTerm) {
    final text = exp.text;
    if (text.length == 6) {
      return Color(exp.value | 0xFF000000);
    } else {
      final value = int.parse(text, radix: 16);
      return Color.fromRGBO(
        _bit4to8(value >> 8),
        _bit4to8(value >> 4),
        _bit4to8(value),
        1,
      );
    }
  }

  throw 'Unknown expression type ${exp.runtimeType}';
}

/// returns Color from css color expression as string
/// supported values:
/// red, blue, 0xFFF, 0xCDCDCD, rgb(0,255,0), rgba(255,255,255,0.5),
/// hsl(89, 43%, 51%), hsla(89, 43%, 51%, 0.9)
Color parseCssColor(String cssColorValue) {
  Expression? exp = parseCssValue(
    'background-color',
    cssColorValue,
  );

  return parseCssColorFromExpression(exp);
}
