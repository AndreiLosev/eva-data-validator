import 'package:eva_data_validator/db/unique_checker.dart';
import 'package:eva_data_validator/validator/rule_parser.dart';
import 'package:eva_data_validator/validator/rules/rule.dart';

class ValidationSchema {
  final String name;
  final Map<String, List<ValidationRule>> fieldRules;

  ValidationSchema({required this.name, required this.fieldRules});

  factory ValidationSchema.fromMap(
    String name,
    Map<dynamic, dynamic> map, {
    UniqueChecker? uniqueChecker,
  }) {
    final fieldRules = <String, List<ValidationRule>>{};
    for (final entry in map.entries) {
      final field = entry.key.toString();
      fieldRules[field] = RuleParser.parse(
        entry.value,
        uniqueChecker: uniqueChecker,
      );
    }
    return ValidationSchema(name: name, fieldRules: fieldRules);
  }
}
