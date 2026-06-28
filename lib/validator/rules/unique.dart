import 'package:eva_data_validator/db/unique_checker.dart';
import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/async_rule.dart';

class UniqueRule extends AsyncValidationRule {
  final String serviceId;
  final String column;
  final String? exceptField;
  final UniqueChecker checker;

  UniqueRule({
    required this.serviceId,
    required this.column,
    required this.checker,
    this.exceptField,
  });

  @override
  String get name => 'unique';

  @override
  Future<String?> validateAsync(
    String attribute,
    dynamic value,
    Map<String, dynamic> record,
    ValidationMessages messages, {
    String? alias,
  }) async {
    dynamic exceptId;
    if (exceptField != null && record.containsKey(exceptField)) {
      exceptId = record[exceptField];
    }

    final taken = await checker.exists(
      serviceId: serviceId,
      column: column,
      value: value,
      exceptId: exceptId,
    );
    if (taken) {
      return messages.unique(attribute, alias);
    }
    return null;
  }
}
