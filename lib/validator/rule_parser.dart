import 'package:eva_data_validator/validator/rules/array_rule.dart';
import 'package:eva_data_validator/validator/rules/between.dart';
import 'package:eva_data_validator/validator/rules/boolean_rule.dart';
import 'package:eva_data_validator/validator/rules/email.dart';
import 'package:eva_data_validator/validator/rules/in_rule.dart';
import 'package:eva_data_validator/validator/rules/integer_rule.dart';
import 'package:eva_data_validator/validator/rules/max.dart';
import 'package:eva_data_validator/validator/rules/min.dart';
import 'package:eva_data_validator/validator/rules/nullable.dart';
import 'package:eva_data_validator/validator/rules/numeric_rule.dart';
import 'package:eva_data_validator/validator/rules/regex.dart';
import 'package:eva_data_validator/validator/rules/required.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';
import 'package:eva_data_validator/validator/rules/size.dart';
import 'package:eva_data_validator/validator/rules/sometimes.dart';
import 'package:eva_data_validator/validator/rules/string_rule.dart';

class RuleParser {
  static List<ValidationRule> parse(dynamic source) {
    if (source is String) {
      return _parsePipeString(source);
    }
    if (source is List) {
      return source.expand((item) => _parsePipeString(item.toString())).toList();
    }
    throw FormatException('rules must be a string or list, got ${source.runtimeType}');
  }

  static List<ValidationRule> _parsePipeString(String source) {
    if (source.trim().isEmpty) {
      throw FormatException('rules string cannot be empty');
    }
    return source.split('|').map(_parseRule).toList();
  }

  static ValidationRule _parseRule(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw FormatException('empty rule in rules string');
    }

    final colonIndex = trimmed.indexOf(':');
    final name = colonIndex == -1 ? trimmed : trimmed.substring(0, colonIndex);
    final param = colonIndex == -1 ? null : trimmed.substring(colonIndex + 1);

    switch (name) {
      case 'required':
        return RequiredRule();
      case 'nullable':
        return NullableRule();
      case 'sometimes':
        return SometimesRule();
      case 'string':
        return StringRule();
      case 'integer':
        return IntegerRule(strict: param == 'strict');
      case 'numeric':
        return NumericRule(strict: param == 'strict');
      case 'boolean':
        return BooleanRule();
      case 'array':
        return ArrayRule();
      case 'email':
        return EmailRule();
      case 'min':
        return MinRule(_parseNum(param, 'min'));
      case 'max':
        return MaxRule(_parseNum(param, 'max'));
      case 'size':
        return SizeRule(_parseNum(param, 'size'));
      case 'between':
        return BetweenRule(
          _parseNum(_splitParam(param, 0, 2), 'between'),
          _parseNum(_splitParam(param, 1, 2), 'between'),
        );
      case 'regex':
        return RegexRule(_parseRegex(param));
      case 'in':
        return InRule(_parseList(param, 'in'));
      case 'not_in':
        return NotInRule(_parseList(param, 'not_in'));
      default:
        throw FormatException('unknown validation rule: $name');
    }
  }

  static num _parseNum(String? param, String ruleName) {
    if (param == null || param.isEmpty) {
      throw FormatException('rule $ruleName requires a parameter');
    }
    final value = num.tryParse(param.trim());
    if (value == null) {
      throw FormatException('rule $ruleName parameter must be numeric');
    }
    return value;
  }

  static String _splitParam(String? param, int index, int expectedParts) {
    if (param == null || param.isEmpty) {
      throw FormatException('rule between requires two parameters');
    }
    final parts = param.split(',');
    if (parts.length != expectedParts) {
      throw FormatException('rule between requires exactly $expectedParts parameters');
    }
    return parts[index].trim();
  }

  static List<String> _parseList(String? param, String ruleName) {
    if (param == null || param.isEmpty) {
      throw FormatException('rule $ruleName requires a parameter');
    }
    return param.split(',').map((e) => e.trim()).toList();
  }

  static RegExp _parseRegex(String? param) {
    if (param == null || param.isEmpty) {
      throw FormatException('rule regex requires a pattern');
    }
    var pattern = param;
    if (pattern.startsWith('/') && pattern.lastIndexOf('/') > 0) {
      final lastSlash = pattern.lastIndexOf('/');
      final body = pattern.substring(1, lastSlash);
      final flags = pattern.substring(lastSlash + 1);
      return RegExp(body, multiLine: flags.contains('m'), caseSensitive: !flags.contains('i'));
    }
    return RegExp(pattern);
  }
}

enum FieldType { string, integer, numeric, boolean, array, unknown }

FieldType fieldTypeFromRules(List<ValidationRule> rules) {
  for (final rule in rules) {
    switch (rule.name) {
      case 'string':
        return FieldType.string;
      case 'integer':
      case 'integer:strict':
        return FieldType.integer;
      case 'numeric':
      case 'numeric:strict':
        return FieldType.numeric;
      case 'boolean':
        return FieldType.boolean;
      case 'array':
        return FieldType.array;
    }
  }
  return FieldType.unknown;
}

bool rulesHaveMarker(List<ValidationRule> rules, String marker) =>
    rules.any((rule) => rule.name == marker);

List<ValidationRule> applicableRules(List<ValidationRule> rules) =>
    rules.where((rule) => rule.name != 'nullable' && rule.name != 'sometimes').toList();

bool isPresenceRule(ValidationRule rule) => rule.name == 'required';

bool isTypeRule(ValidationRule rule) {
  final base = rule.name.split(':').first;
  return {
    'string',
    'integer',
    'numeric',
    'boolean',
    'array',
    'email',
  }.contains(base);
}

bool isConstraintRule(ValidationRule rule) =>
    !isPresenceRule(rule) && !isTypeRule(rule);
