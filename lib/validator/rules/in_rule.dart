import 'package:eva_data_validator/validator/rules/rule.dart';

class InRule extends ValidationRule {
  final List<String> allowed;

  InRule(this.allowed);

  @override
  String get name => 'in';

  @override
  String? validate(String attribute, dynamic value) {
    final text = value?.toString() ?? '';
    if (allowed.contains(text)) return null;
    return 'The selected ${formatAttribute(attribute)} is invalid.';
  }
}

class NotInRule extends ValidationRule {
  final List<String> forbidden;

  NotInRule(this.forbidden);

  @override
  String get name => 'not_in';

  @override
  String? validate(String attribute, dynamic value) {
    final text = value?.toString() ?? '';
    if (!forbidden.contains(text)) return null;
    return 'The selected ${formatAttribute(attribute)} is invalid.';
  }
}
