import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css.dart';
import 'package:im_themed/src/css/parse_css_color.dart';
import 'package:im_themed/src/css/parse_css_font_weight.dart';
import 'package:im_themed/src/css/parse_css_length.dart';
import 'package:im_themed/third-party/csslib/visitor.dart';

String removeSingleOrDoubleQuotes(String s) {
  if (s.startsWith('\'') && s.endsWith('\'')) {
    return s.substring(1, s.length - 1);
  }

  if (s.startsWith('"') && s.endsWith('"')) return s.substring(1, s.length - 1);

  return s;
}

FontStyle parseFontStyle(String cssValue) {
  const supportedFontStyles = {
    'normal': FontStyle.normal,
    'italic': FontStyle.italic,
  };

  final returnValue = supportedFontStyles[cssValue.trim().toLowerCase()];

  if (returnValue == null) throw 'can not parse fontStyle "$cssValue"';

  return returnValue;
}

/// returns TextStyle from css font shorthand value
/// reference: https://developer.mozilla.org/en-US/docs/Web/CSS/font
/// **font-variant**, **font-stretch** properties are not yet supported
/// only **normal**, **italic** font-styles are supported so far
TextStyle parseCssFont(String cssFontValue) {
  Expressions declaration = parseCssDeclaration(
    'font',
    cssFontValue,
  );

  final List<String> fontFamilies = [];
  double? fontSize;
  double? lineHeight;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  Color? fontColor;

  Expression? previousExp;
  for (var exp in declaration.expressions) {
    // exp is line-height
    if (fontSize != null && (exp is LengthTerm || exp is NumberTerm)) {
      if (previousExp is! OperatorSlash) {
        throw 'font-size may be followed by "/ line-height font-families" or "font-families" only';
      }

      lineHeight = exp is LengthTerm
          ? parseCssLengthFromExpression(exp) / fontSize
          : (exp as NumberTerm).value.toDouble();
    }
    // exp is font-size
    else if (exp is LengthTerm) {
      if (fontSize != null) {
        throw 'font shorthand can have only one Length value, font-size';
      }

      fontSize = parseCssLengthFromExpression(exp);
    }
    // color
    else if (exp is FunctionTerm || exp is HexColorTerm) {
      try {
        fontColor = parseCssColorFromExpression(exp);
      } catch (error) {
        throw 'error parsing font color $exp';
      }
    }
    // strings
    else if (exp is LiteralTerm || exp is NumberTerm) {
      if (fontSize != null && exp is NumberTerm) {
        throw 'font-size may be followed by "/ line-height font-families" or "font-families" only';
      }

      // exp should be font-weight or font-style
      if (fontSize == null) {
        if (exp is NumberTerm) {
          fontWeight = parseCssFontWeight(exp.text);
        } else if (exp is LiteralTerm) {
          try {
            fontStyle = parseFontStyle(exp.text);
          } catch (_) {
            try {
              fontWeight = parseCssFontWeight(exp.text);
            } catch (_) {
              try {
                fontColor = parseCssColorFromExpression(exp);
              } catch (error) {
                '"${exp.text}" can not be parsed as font-style nor font-weight';
              }
            }
          }
        }
      }
      // exp is a font family
      else {
        if (exp is LiteralTerm) {
          fontFamilies.add(removeSingleOrDoubleQuotes(exp.text));
        } else {
          throw 'expect font family, got "${(exp as NumberTerm).text}"';
        }
      }
    }
    // other allowed operators: OperatorSlash
    else if (exp is OperatorSlash) {
      if (fontSize == null) throw '"/" can only follow font-size';
    }
    // other allowed operators: OperatorComma
    else if (exp is OperatorComma) {
      if (fontFamilies.isEmpty) throw '"," can only separate font-family names';
    }

    previousExp = exp;
  }

  return TextStyle(
    fontFamily: fontFamilies.isNotEmpty ? fontFamilies.first : null,
    fontFamilyFallback:
        fontFamilies.length > 1 ? fontFamilies.sublist(1) : null,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    fontSize: fontSize,
    height: lineHeight,
    color: fontColor,
  );
}
