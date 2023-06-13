import 'dart:math';

import 'package:im_themed/third-party/csslib/parser.dart' as css;
import 'package:im_themed/third-party/csslib/visitor.dart';

double angleTermToRadians(AngleTerm term) {
  switch (term.unit) {
    case css.TokenKind.UNIT_ANGLE_RAD:
      return term.value;
    case css.TokenKind.UNIT_ANGLE_DEG:
      return term.value / 180 * pi;
    case css.TokenKind.UNIT_ANGLE_TURN:
      return term.value * 2 * pi;
    default:
      return 0;
  }
}
