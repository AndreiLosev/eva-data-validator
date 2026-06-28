import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class StringRule extends ValidationRule {
  @override
  String get name => 'string';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    if (value is String) return null;
    return messages.string(attribute);
  }
}
