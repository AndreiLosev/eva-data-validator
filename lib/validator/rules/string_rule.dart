import 'package:eva_data_validator/validator/rules/rule.dart';

class StringRule extends ValidationRule {
  @override
  String get name => 'string';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is String) return null;
    return 'The ${formatAttribute(attribute)} must be a string.';
  }
}
