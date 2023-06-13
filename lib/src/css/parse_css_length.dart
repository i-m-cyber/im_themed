import 'package:im_themed/src/css/parse_css.dart';
import 'package:im_themed/third-party/csslib/parser.dart';
import 'package:im_themed/third-party/csslib/visitor.dart';

RegExp regExp = RegExp(
  r"^\s*([+-]?[0-9]+\.?[0-9]*|\.[0-9]+)(px|pt)?\s*",
  caseSensitive: false,
  multiLine: false,
);

const _unitsToPxMap = <int, double>{
  TokenKind.UNIT_LENGTH_PX: 1,
  TokenKind.UNIT_LENGTH_PT: 96 / 72,
};

double unitsToPx(int unit) {
  if (!_unitsToPxMap.containsKey(unit)) {
    throw 'unsupported CSS units "$unit"';
  }

  return _unitsToPxMap[unit]!;
}

/// parses cssLength from Expression
/// supported units are map keys defined in _unitsToPxMap
/// and numbers with no units
double parseCssLengthFromExpression(Expression exp) {
  if (exp is LengthTerm) {
    return exp.value * unitsToPx(exp.unit);
  }

  if (exp is NumberTerm) {
    return exp.value.toDouble();
  }

  throw 'can not parse CSS Length "${exp.span}". Unsupported units ${exp.runtimeType}';
}

/// parses cssLength from String
/// supported units are map keys defined in _unitsToPxMap
/// and numbers with no units
double parseCssLength(dynamic cssLength) {
  if (cssLength is num) return cssLength.toDouble();
  final exp = parseCssValue('font-size', cssLength)!;
  return parseCssLengthFromExpression(exp);
}
