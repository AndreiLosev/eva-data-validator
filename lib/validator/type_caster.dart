import 'package:eva_data_validator/validator/rule_parser.dart';
import 'package:eva_data_validator/validator/rules/boolean_rule.dart';

class TypeCaster {
  static dynamic cast(dynamic value, FieldType type) {
    if (value == null) return null;

    return switch (type) {
      FieldType.string => value.toString(),
      FieldType.integer => _castInteger(value),
      FieldType.numeric => _castNumeric(value),
      FieldType.boolean => _castBoolean(value),
      FieldType.array => _castArray(value),
      FieldType.unknown => value,
    };
  }

  static int _castInteger(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('cannot cast $value to integer');
  }

  static num _castNumeric(dynamic value) {
    if (value is num) return value;
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('cannot cast $value to numeric');
  }

  static bool _castBoolean(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      if (BooleanRule.truthy.contains(lower)) return true;
      if (BooleanRule.falsy.contains(lower)) return false;
    }
    throw FormatException('cannot cast $value to boolean');
  }

  static List<dynamic> _castArray(dynamic value) {
    if (value is List) return List<dynamic>.from(value);
    throw FormatException('cannot cast $value to array');
  }
}
