import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class InRule extends ValidationRule {
  final List<String> allowed;

  InRule(this.allowed);

  @override
  String get name => 'in';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    final text = value?.toString() ?? '';
    if (allowed.contains(text)) return null;
    return messages.inInvalid(attribute);
  }
}

class NotInRule extends ValidationRule {
  final List<String> forbidden;

  NotInRule(this.forbidden);

  @override
  String get name => 'not_in';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    final text = value?.toString() ?? '';
    if (!forbidden.contains(text)) return null;
    return messages.notInInvalid(attribute);
  }
}
