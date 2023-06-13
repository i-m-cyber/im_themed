import 'package:im_themed/third-party/csslib/parser.dart' as css;
import 'package:im_themed/third-party/csslib/visitor.dart';

const _default = css.PreprocessorOptions(
  useColors: false,
  checked: false,
  warningsAsErrors: false,
  inputFile: 'memory',
);

class CssParseError extends Error {
  CssParseError(List<dynamic> errors) : super() {
    this.errors =
        errors.map((errorMessage) => errorMessage.toString()).toList();
  }

  late final List<String> errors;

  @override
  String toString() {
    return errors.join('\n');
  }
}

/// Spin-up CSS parser in checked mode to detect any problematic CSS.  Normally,
/// CSS will allow any property/value pairs regardless of validity; all of our
/// tests (by default) will ensure that the CSS is really valid.
StyleSheet parseCss(
  String cssInput, {
  css.PreprocessorOptions? opts,
}) {
  var errors = <css.Message>[];

  if (errors.isNotEmpty) {
    throw CssParseError(errors);
  }

  return css.parse(cssInput, errors: errors, options: opts ?? _default);
}

// Pretty printer for CSS.
var emitCss = CssPrinter();
String prettyPrint(StyleSheet ss) =>
    (emitCss..visitTree(ss, pretty: true)).toString();

Expressions parseCssDeclaration(String propertyName, String propertyValue) {
  var parsed = parseCss(
    '*{$propertyName:$propertyValue;}',
  );

  RuleSet ruleSet = parsed.topLevels.first as RuleSet;
  Declaration declaration =
      ruleSet.declarationGroup.declarations.first as Declaration;

  return (declaration.expression as Expressions);
}

Expression? parseCssValue(String propertyName, String propertyValue) {
  var parsed = parseCss(
    '*{$propertyName:$propertyValue;}',
  );

  RuleSet ruleSet = parsed.topLevels.first as RuleSet;
  Declaration declaration =
      ruleSet.declarationGroup.declarations.first as Declaration;

  return (declaration.expression as Expressions).expressions.first;
}
