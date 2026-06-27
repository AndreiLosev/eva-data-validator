import 'package:eva_data_validator/validator/rules/rule.dart';

class MinRule extends ValidationRule {
  final num limit;

  MinRule(this.limit);

  @override
  String get name => 'min';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is String) {
      if (value.length >= limit) return null;
      return 'The ${formatAttribute(attribute)} must be at least $limit characters.';
    }
    if (value is List) {
      if (value.length >= limit) return null;
      return 'The ${formatAttribute(attribute)} must have at least $limit items.';
    }
    final num? n = _asNum(value);
    if (n != null) {
      if (n >= limit) return null;
      return 'The ${formatAttribute(attribute)} must be at least $limit.';
    }
    return 'The ${formatAttribute(attribute)} must be at least $limit.';
  }

  num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}
