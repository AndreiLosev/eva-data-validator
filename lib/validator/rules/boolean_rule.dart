import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class BooleanRule extends ValidationRule {
  static const truthy = {'true', '1', 'yes', 'on'};
  static const falsy = {'false', '0', 'no', 'off'};

  @override
  String get name => 'boolean';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages, {
    String? alias,
  }) {
    if (value is bool) return null;
    if (value is int && (value == 0 || value == 1)) return null;
    if (value is String) {
      final lower = value.toLowerCase();
      if (truthy.contains(lower) || falsy.contains(lower)) return null;
    }
    return messages.boolean(attribute, alias);
  }
}
