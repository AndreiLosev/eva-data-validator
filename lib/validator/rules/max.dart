import 'package:eva_data_validator/validator/rules/rule.dart';

class MaxRule extends ValidationRule {
  final num limit;

  MaxRule(this.limit);

  @override
  String get name => 'max';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is String) {
      if (value.length <= limit) return null;
      return 'The ${formatAttribute(attribute)} must not be greater than $limit characters.';
    }
    if (value is List) {
      if (value.length <= limit) return null;
      return 'The ${formatAttribute(attribute)} must not have more than $limit items.';
    }
    final num? n = _asNum(value);
    if (n != null) {
      if (n <= limit) return null;
      return 'The ${formatAttribute(attribute)} must not be greater than $limit.';
    }
    return 'The ${formatAttribute(attribute)} must not be greater than $limit.';
  }

  num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}
