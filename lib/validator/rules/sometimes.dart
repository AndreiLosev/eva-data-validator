import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

/// Marker rule — handled by the engine before other rules run.
class SometimesRule extends ValidationRule {
  @override
  String get name => 'sometimes';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages, {
    String? alias,
  }) =>
      null;
}
