import 'package:eva_data_validator/validator/rules/rule.dart';

class ArrayRule extends ValidationRule {
  @override
  String get name => 'array';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is List) return null;
    return 'The ${formatAttribute(attribute)} must be an array.';
  }
}
