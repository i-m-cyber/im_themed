import 'dart:ui';

const fontWeightMap = <String, FontWeight>{
  '100': FontWeight.w100,
  '200': FontWeight.w200,
  '300': FontWeight.w300,
  '400': FontWeight.w400,
  '500': FontWeight.w500,
  '600': FontWeight.w600,
  '700': FontWeight.w700,
  '800': FontWeight.w800,
  '900': FontWeight.w900,
  'thin': FontWeight.w100,
  'hairline': FontWeight.w100,
  'extralight': FontWeight.w200,
  'ultralight': FontWeight.w200,
  'light': FontWeight.w300,
  'normal': FontWeight.w400,
  'regular': FontWeight.w400,
  'medium': FontWeight.w500,
  'semibold': FontWeight.w600,
  'demibold': FontWeight.w600,
  'bold': FontWeight.w700,
  'extrabold': FontWeight.w800,
  'ultrabold': FontWeight.w800,
  'black': FontWeight.w900,
  'heavy': FontWeight.w900,
};

FontWeight parseCssFontWeight(String cssValue) {
  final returnValue =
      fontWeightMap[cssValue.toLowerCase().replaceAll(RegExp(r'\s|\-|_'), '')];

  if (returnValue == null) throw 'Can not parse css font weight: "$cssValue"';

  return returnValue;
}
