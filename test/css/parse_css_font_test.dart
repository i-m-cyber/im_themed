import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:im_themed/src/css/parse_css_font.dart';

void main() {
  group('parseCssFont', () {
    test('parses minimal font shorthand correctly', () {
      const cssFontValue = 'italic bold 12px Arial';
      final textStyle = parseCssFont(cssFontValue);
      expect(textStyle.fontStyle, FontStyle.italic);
      expect(textStyle.fontWeight, FontWeight.bold);
      expect(textStyle.fontSize, 12);
      expect(textStyle.fontFamily, 'Arial');
    });

    test('parses full font shorthand with line-height and color', () {
      const cssFontValue = 'italic bold 12px/14px Arial, sans-serif #ff0000';
      final textStyle = parseCssFont(cssFontValue);
      expect(textStyle.fontStyle, FontStyle.italic);
      expect(textStyle.fontWeight, FontWeight.bold);
      expect(textStyle.fontSize, 12);
      expect(textStyle.height, 14 / 12);
      expect(textStyle.fontFamily, 'Arial');
      expect(textStyle.fontFamilyFallback, ['sans-serif']);
      expect(textStyle.color, const Color(0xffff0000));
    });

    test('parses font shorthand with multiple font-families', () {
      const cssFontValue = '12px Arial, "Helvetica Neue", sans-serif';
      final textStyle = parseCssFont(cssFontValue);
      expect(textStyle.fontSize, 12);
      expect(textStyle.fontFamily, 'Arial');
      expect(textStyle.fontFamilyFallback, ['Helvetica Neue', 'sans-serif']);
    });

    test('parses font shorthand with font-style only', () {
      const cssFontValue = 'italic Arial';
      final textStyle = parseCssFont(cssFontValue);
      expect(textStyle.fontStyle, FontStyle.italic);
      expect(textStyle.fontFamily, 'Arial');
    });

    test('parses font shorthand with numeric and named font-weight', () {
      const cssFontValueNumeric = 'italic 500 12px Arial';
      const cssFontValueNamed = 'italic bold 12px Arial';
      final textStyleNumeric = parseCssFont(cssFontValueNumeric);
      final textStyleNamed = parseCssFont(cssFontValueNamed);
      expect(textStyleNumeric.fontWeight, FontWeight.w500);
      expect(textStyleNamed.fontWeight, FontWeight.bold);
    });

    test('throws when font-size is followed by invalid property', () {
      const cssFontValue = '12px Arial / 15px';
      expect(() => parseCssFont(cssFontValue), throwsException);
    });

    test('throws when font shorthand is missing required properties', () {
      const cssFontValue = 'bold Arial';
      expect(() => parseCssFont(cssFontValue), throwsException);
    });
  });
}
