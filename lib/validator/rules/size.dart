import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class SizeRule extends ValidationRule {
  final num size;

  SizeRule(this.size);

  @override
  String get name => 'size';

  @override
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  ) {
    if (value is String) {
      if (value.length == size) return null;
      return messages.sizeChars(attribute, size);
    }
    if (value is List) {
      if (value.length == size) return null;
      return messages.sizeItems(attribute, size);
    }
    final num? n = _asNum(value);
    if (n != null) {
      if (n == size) return null;
      return messages.sizeValue(attribute, size);
    }
    return messages.sizeGeneric(attribute, size);
  }

  num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}
