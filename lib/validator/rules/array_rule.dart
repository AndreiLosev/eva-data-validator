import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class ArrayRule extends ValidationRule {
  @override
  String get name => 'array';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages, {
    String? alias,
  }) {
    if (value is List) return null;
    return messages.array(attribute, alias);
  }
}
