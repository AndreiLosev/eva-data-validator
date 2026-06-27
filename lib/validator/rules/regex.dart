import 'package:eva_data_validator/validator/rules/rule.dart';

class RegexRule extends ValidationRule {
  final RegExp pattern;

  RegexRule(this.pattern);

  @override
  String get name => 'regex';

  @override
  String? validate(String attribute, dynamic value) {
    final text = value?.toString() ?? '';
    if (pattern.hasMatch(text)) return null;
    return 'The ${formatAttribute(attribute)} format is invalid.';
  }
}
