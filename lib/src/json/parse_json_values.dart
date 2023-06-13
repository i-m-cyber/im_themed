import 'package:flutter/material.dart';

///
/// parseJsonValues will return new map with same keys but with parsed values
/// using parserMap functions for parsing
///
/// /// example:
///
/// parserMap = { 'company': companyFromStringFn, 'person': personFromStringFn }
///
/// dataMap = {
///   'company': '{ "name": "Tesla", "industry": "automotive" }',
///   'person': '{ "name": "Elon Musk", "role": "CEO" }',
/// }
///
/// returnValue = {
///   'company': Company(name: 'Tesla', industry: 'automotive'),
///   'person': Person(name: 'Elon Musk', role: 'CEO'),
/// }
///

Map<String, dynamic> parseJsonValues({
  required Map<String, dynamic Function(String)> parserMap,
  required Map<String, String> dataMap,
  bool useCache = true,
}) {
  // use cache to prevent double parsing same data using same parser function
  // because we expect parsers to be pure functions
  // Map<FieldValue, Map<ParserFunction, ReturnValue<ParserFunction>>>
  final cache = <String, Map<Function, dynamic>>{};
  final processedKeys = <String>{};
  final result = <String, dynamic>{};

  for (var entry in parserMap.entries) {
    final key = entry.key;
    final parser = entry.value;

    processedKeys.add(key);

    if (dataMap[key] == null) {
      debugPrint('JSON data missing entry $key');
    } else {
      dynamic value;
      bool readFromCache = false;

      final dataValue = dataMap[key]!;

      if (useCache) {
        final parsedByField = cache[dataValue];
        if (parsedByField != null) {
          if (parsedByField.containsKey(parser)) {
            readFromCache = true;
            value = parsedByField[parser];
          }
        }
      }

      if (!readFromCache) {
        // parser may throw an Error !
        try {
          value = Function.apply(
            parser,
            [dataValue],
          );
        } catch (error) {
          print('parseJsonValues: $error');
        }

        if (useCache) {
          cache[dataValue] ??= {};
          cache[dataValue]![parser] = value;
        }
      }

      result[key] = value;
    }
  }

  for (var dataKey in dataMap.keys) {
    if (!processedKeys.contains(dataKey)) {
      debugPrint('found ignored JSON key $dataKey');
    }
  }

  return result;
}
