import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

final _emailPattern = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

class EmailRule extends ValidationRule {
  @override
  String get name => 'email';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    final text = value?.toString() ?? '';
    if (_emailPattern.hasMatch(text)) return null;
    return messages.email(attribute);
  }
}
