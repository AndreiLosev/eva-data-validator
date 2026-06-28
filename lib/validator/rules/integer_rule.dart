import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class IntegerRule extends ValidationRule {
  final bool strict;

  IntegerRule({this.strict = false});

  @override
  String get name => strict ? 'integer:strict' : 'integer';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages, {
    String? alias,
  }) {
    if (value is int && value is! double) return null;
    if (!strict && value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null && !value.contains('.')) return null;
    }
    return messages.integer(attribute, alias);
  }
}
