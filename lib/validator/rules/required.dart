import 'package:eva_data_validator/validator/rules/rule.dart';

class RequiredRule extends ValidationRule {
  @override
  String get name => 'required';

  @override
  String? validate(String attribute, dynamic value) {
    if (value == null) {
      return 'The ${formatAttribute(attribute)} field is required.';
    }
    if (value is String && value.isEmpty) {
      return 'The ${formatAttribute(attribute)} field is required.';
    }
    if (value is List && value.isEmpty) {
      return 'The ${formatAttribute(attribute)} field is required.';
    }
    if (value is Map && value.isEmpty) {
      return 'The ${formatAttribute(attribute)} field is required.';
    }
    return null;
  }
}
