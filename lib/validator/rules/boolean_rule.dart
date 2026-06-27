import 'package:eva_data_validator/validator/rules/rule.dart';

class BooleanRule extends ValidationRule {
  static const truthy = {'true', '1', 'yes', 'on'};
  static const falsy = {'false', '0', 'no', 'off'};

  @override
  String get name => 'boolean';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is bool) return null;
    if (value is int && (value == 0 || value == 1)) return null;
    if (value is String) {
      final lower = value.toLowerCase();
      if (truthy.contains(lower) || falsy.contains(lower)) return null;
    }
    return 'The ${formatAttribute(attribute)} field must be true or false.';
  }
}
