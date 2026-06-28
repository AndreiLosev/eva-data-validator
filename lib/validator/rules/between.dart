import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class BetweenRule extends ValidationRule {
  final num min;
  final num max;

  BetweenRule(this.min, this.max);

  @override
  String get name => 'between';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages, {
    String? alias,
  }) {
    if (value is String) {
      final len = value.length;
      if (len >= min && len <= max) return null;
      return messages.betweenChars(attribute, min, max, alias);
    }
    if (value is List) {
      final len = value.length;
      if (len >= min && len <= max) return null;
      return messages.betweenItems(attribute, min, max, alias);
    }
    final num? n = _asNum(value);
    if (n != null) {
      if (n >= min && n <= max) return null;
      return messages.betweenValue(attribute, min, max, alias);
    }
    return messages.betweenGeneric(attribute, min, max, alias);
  }

  num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}
