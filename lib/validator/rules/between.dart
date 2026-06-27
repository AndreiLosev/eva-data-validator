import 'package:eva_data_validator/validator/rules/rule.dart';

class BetweenRule extends ValidationRule {
  final num min;
  final num max;

  BetweenRule(this.min, this.max);

  @override
  String get name => 'between';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is String) {
      final len = value.length;
      if (len >= min && len <= max) return null;
      return 'The ${formatAttribute(attribute)} must be between $min and $max characters.';
    }
    if (value is List) {
      final len = value.length;
      if (len >= min && len <= max) return null;
      return 'The ${formatAttribute(attribute)} must have between $min and $max items.';
    }
    final num? n = _asNum(value);
    if (n != null) {
      if (n >= min && n <= max) return null;
      return 'The ${formatAttribute(attribute)} must be between $min and $max.';
    }
    return 'The ${formatAttribute(attribute)} must be between $min and $max.';
  }

  num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}
