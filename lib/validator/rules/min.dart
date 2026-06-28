import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class MinRule extends ValidationRule {
  final num limit;

  MinRule(this.limit);

  @override
  String get name => 'min';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    if (value is String) {
      if (value.length >= limit) return null;
      return messages.minChars(attribute, limit);
    }
    if (value is List) {
      if (value.length >= limit) return null;
      return messages.minItems(attribute, limit);
    }
    final num? n = _asNum(value);
    if (n != null) {
      if (n >= limit) return null;
      return messages.minValue(attribute, limit);
    }
    return messages.minGeneric(attribute, limit);
  }

  num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}
