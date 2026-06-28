import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class NumericRule extends ValidationRule {
  final bool strict;

  NumericRule({this.strict = false});

  @override
  String get name => strict ? 'numeric:strict' : 'numeric';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    if (value is num) return null;
    if (!strict && value is String && num.tryParse(value) != null) return null;
    return messages.numeric(attribute);
  }
}
