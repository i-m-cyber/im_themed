Map<String, dynamic> mapFromEntryList(
  List<Map>? list, {
  keyPropertyName = 'key',
  valuePropertyName = 'value',
}) {
  final map = <String, dynamic>{};

  if (list != null) {
    for (var element in list) {
      map[element[keyPropertyName].trim()] = element[valuePropertyName].trim();
    }
  }

  return map;
}
