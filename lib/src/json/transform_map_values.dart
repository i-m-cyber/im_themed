/// transforms [map] values
/// using [transformers] functions
/// only keys specified by [transformers] will be transformed
void transformMapValues({
  required Map<String, dynamic> map,
  required Map<String, Function> transformers,
}) {
  for (var entry in transformers.entries) {
    final key = entry.key;
    final transformer = entry.value;
    if (map.containsKey(key)) {
      map[key] = transformer(map[key]);
    }
  }
}
