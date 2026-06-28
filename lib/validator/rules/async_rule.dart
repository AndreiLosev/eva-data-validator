import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

abstract class AsyncValidationRule extends ValidationRule {
  Future<String?> validateAsync(
    String attribute,
    dynamic value,
    Map<String, dynamic> record,
    ValidationMessages messages, {
    String? alias,
  });

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages, {
    String? alias,
  }) =>
      throw UnsupportedError('use validateAsync');
}
