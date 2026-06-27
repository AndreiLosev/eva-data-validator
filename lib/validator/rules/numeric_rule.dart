import 'package:eva_data_validator/validator/rules/rule.dart';

class NumericRule extends ValidationRule {
  final bool strict;

  NumericRule({this.strict = false});

  @override
  String get name => strict ? 'numeric:strict' : 'numeric';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is num) return null;
    if (!strict && value is String) {
      if (num.tryParse(value) != null) return null;
    }
    return 'The ${formatAttribute(attribute)} must be a number.';
  }
}
