import 'dart:collection';

const referencePrefix = '{{';
const referenceSuffix = '}}';
const referenceEscape = '\\';
const escapedReferencePrefix = '$referenceEscape$referencePrefix';

class Reference {
  Reference(this.name);
  final String name;

  @override
  bool operator ==(Object other) {
    return other is Reference && name == other.name;
  }

  @override
  String toString() {
    return 'Reference($name)';
  }


}

class ReferenceExpression {
  ReferenceExpression(this._segments)
      : assert(_segments
            .every((segment) => segment is String || segment is Reference));

  final List<dynamic> _segments;
  List<dynamic>? _dependencies;

  bool get hasDependencies {
    return _segments.length > 1 ||
        (_segments.length == 1 && _segments.first is Reference);
  }

  List<dynamic> get segments {
    return UnmodifiableListView(_segments);
  }

  List<Reference> get dependencies {
    _dependencies ??= segments.whereType<Reference>().toList();
    return UnmodifiableListView(_dependencies?.cast<Reference>() as dynamic);
  }

  String compile(
    Map<String, String> values, {
    String? fallbackValue,
  }) {
    String getFromMap(String key) {
      if (values[key] == null && fallbackValue == null) {
        throw 'can not find referenced value "$key". Try setting fallbackValue in ReferenceExpression.compile() call';
      }

      return values[key] ?? fallbackValue as String;
    }

    return _segments
        .map(
          (segment) => segment is Reference
              ? getFromMap(segment.name)
              : segment as String,
        )
        .toList()
        .join();
  }

  @override
  bool operator ==(Object other) {
    bool compareSegments(List<dynamic> a, List<dynamic> b) {
      if (a.length != b.length) return false;

      for (var i = 0; i < a.length; i++) {
        if (a[i] != b[i]) return false;
      }

      return true;
    }

    return other is ReferenceExpression &&
        compareSegments(_segments, other._segments);
  }

  factory ReferenceExpression.fromString(String expression) {
    if (expression.isEmpty) {
      return ReferenceExpression([]);
    }

    final segments = [];
    var index = 0;
    var processed = 0;
    var referenceOpen = false;

    while (index <= expression.length) {
      // if referenceOpen look for reference closing
      if (referenceOpen) {
        var referenceClosingIndex = expression.indexOf(referenceSuffix, index);

        if (referenceClosingIndex < 0) {
          throw 'Can not find reference closure';
        }

        segments.add(Reference(
            expression.substring(index, referenceClosingIndex).trim()));

        referenceOpen = false;
        index = referenceClosingIndex + referenceSuffix.length;
        processed = index;
      }
      // looking for reference opening
      else {
        index = expression.indexOf(referencePrefix, index);

        if (index < 0) {
          index = 0;
          break;
        }

        // is it reference escape: it is "\{{" instead of "{{"
        final potentialEscapeIndex = index - referenceEscape.length;
        final escapingReference = potentialEscapeIndex >= 0 &&
            expression.startsWith(referenceEscape, potentialEscapeIndex);

        if (escapingReference) {
          index += referencePrefix.length;
          continue;
        }

        // add string before current reference to _segments
        if (index > processed) {
          segments.add(
            expression
                .substring(processed, index)
                .replaceAll(escapedReferencePrefix, referencePrefix),
          );
        }
        processed = index;

        // mark reference as open
        index += referencePrefix.length;
        referenceOpen = true;
      }
    }

    if (referenceOpen) {
      throw 'Can not find reference closure';
    }

    if (processed < expression.length) {
      segments.add(
        expression
            .substring(processed)
            .replaceAll(escapedReferencePrefix, referencePrefix),
      );
    }

    return ReferenceExpression(segments);
  }

  @override
  String toString() {
    final segmentList = _segments
        .map((segment) => segment is String ? '"$segment"' : segment.toString())
        .toList();

    final content =
        segmentList.isEmpty ? '' : '[\n${segmentList.join(',\n')}\n]';

    return 'ReferenceExpression($content)';
  }


}
