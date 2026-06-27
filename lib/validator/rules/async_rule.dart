import 'package:eva_data_validator/validator/rules/rule.dart';

abstract class AsyncValidationRule extends ValidationRule {
  Future<String?> validateAsync(
    String attribute,
    dynamic value,
    Map<String, dynamic> record,
  );

  @override
  String? validate(String attribute, dynamic value) =>
      throw UnsupportedError('use validateAsync');
}
