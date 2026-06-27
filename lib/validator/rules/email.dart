import 'package:eva_data_validator/validator/rules/rule.dart';

final _emailPattern = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

class EmailRule extends ValidationRule {
  @override
  String get name => 'email';

  @override
  String? validate(String attribute, dynamic value) {
    final text = value?.toString() ?? '';
    if (_emailPattern.hasMatch(text)) return null;
    return 'The ${formatAttribute(attribute)} must be a valid email address.';
  }
}
