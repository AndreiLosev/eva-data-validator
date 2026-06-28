import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class RequiredRule extends ValidationRule {
  @override
  String get name => 'required';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    if (value == null) {
      return messages.required(attribute);
    }
    if (value is String && value.isEmpty) {
      return messages.required(attribute);
    }
    if (value is List && value.isEmpty) {
      return messages.required(attribute);
    }
    if (value is Map && value.isEmpty) {
      return messages.required(attribute);
    }
    return null;
  }
}
