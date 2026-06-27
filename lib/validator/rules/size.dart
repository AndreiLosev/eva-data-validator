import 'package:eva_data_validator/validator/rules/rule.dart';

class SizeRule extends ValidationRule {
  final num size;

  SizeRule(this.size);

  @override
  String get name => 'size';

  @override
  String? validate(String attribute, dynamic value) {
    if (value is String) {
      if (value.length == size) return null;
      return 'The ${formatAttribute(attribute)} must be $size characters.';
    }
    if (value is List) {
      if (value.length == size) return null;
      return 'The ${formatAttribute(attribute)} must contain $size items.';
    }
    final num? n = _asNum(value);
    if (n != null) {
      if (n == size) return null;
      return 'The ${formatAttribute(attribute)} must be $size.';
    }
    return 'The ${formatAttribute(attribute)} must be $size.';
  }

  num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}
