import 'package:eva_data_validator/config/config.dart';
import 'package:eva_data_validator/config/validation_schema.dart';
import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:eva_data_validator/validator/rule_parser.dart';
import 'package:eva_data_validator/validator/rules/async_rule.dart';
import 'package:eva_data_validator/validator/type_caster.dart';
import 'package:eva_data_validator/validator/validation_result.dart';

class ValidatorEngine {
  static ValidatorEngine? _instance;

  final Config config;
  final ValidationMessages messages;

  ValidatorEngine._(this.config)
      : messages = ValidationMessages.forLocale(config.locale);

  factory ValidatorEngine.getInstance([Config? config]) {
    if (_instance == null && config == null) {
      throw StateError('ValidatorEngine is not initialized');
    }
    _instance ??= ValidatorEngine._(config!);
    return _instance!;
  }

  static void resetForTests() => _instance = null;

  ValidationSchema? findSchema(String name) => config.schema(name);

  Future<ValidationResult> validate(String name, List<dynamic> data, {Map<String, String>? fieldAliases}) async {
    final schema = config.schema(name);
    if (schema == null) {
      throw ArgumentError('unknown validation schema: $name');
    }

    final allErrors = <String, List<String>>{};
    final validatedRows = <Map<String, dynamic>>[];

    for (var index = 0; index < data.length; index++) {
      final item = data[index];
      if (item is! Map) {
        throw ArgumentError('data[$index] must be a dict');
      }
      final record = Map<String, dynamic>.from(item.cast());
      final prefix = '$index.';
      final result = await _validateRecord(record, schema, prefix, fieldAliases: fieldAliases);
      if (result.errors.isNotEmpty) {
        allErrors.addAll(result.errors);
      } else if (result.validated != null) {
        validatedRows.add(result.validated!);
      }
    }

    if (allErrors.isNotEmpty) {
      return ValidationResult.failure(allErrors);
    }
    return ValidationResult.success(validatedRows);
  }

  Future<_RecordResult> _validateRecord(
    Map<String, dynamic> data,
    ValidationSchema schema,
    String prefix, {
    Map<String, String>? fieldAliases,
  }) async {
    final errors = <String, List<String>>{};
    final validated = <String, dynamic>{};

    for (final entry in schema.fieldRules.entries) {
      final field = entry.key;
      final rules = entry.value;
      final errorKey = '$prefix$field';

      if (rulesHaveMarker(rules, 'sometimes') && !data.containsKey(field)) {
        continue;
      }

      final value = data[field];

      if (rulesHaveMarker(rules, 'nullable') && value == null) {
        validated[field] = null;
        continue;
      }

      final fieldType = fieldTypeFromRules(rules);
      final fieldErrors = <String>[];

      final alias = fieldAliases?[field];
      
      for (final rule in applicableRules(rules).where(isPresenceRule)) {
        final message = rule.validate(errorKey, value, messages, alias: alias);
        if (message != null) {
          fieldErrors.add(message);
          break;
        }
      }

      if (fieldErrors.isEmpty) {
        for (final rule in applicableRules(rules).where(isTypeRule)) {
          final message = rule.validate(errorKey, value, messages, alias: alias);
          if (message != null) {
            fieldErrors.add(message);
            break;
          }
        }
      }

      if (fieldErrors.isEmpty) {
        final constraintValue = _constraintValue(value, fieldType);
        for (final rule in applicableRules(rules).where(isConstraintRule)) {
          final message = rule.validate(errorKey, constraintValue, messages, alias: alias);
          if (message != null) {
            fieldErrors.add(message);
            break;
          }
        }
      }

      if (fieldErrors.isEmpty) {
        final constraintValue = _constraintValue(value, fieldType);
        for (final rule in applicableRules(rules).where(isAsyncRule)) {
          final message = await (rule as AsyncValidationRule).validateAsync(
            errorKey,
            constraintValue,
            data,
            messages,
            alias: alias,
          );
          if (message != null) {
            fieldErrors.add(message);
            break;
          }
        }
      }

      if (fieldErrors.isNotEmpty) {
        errors[errorKey] = fieldErrors;
        continue;
      }

      validated[field] = TypeCaster.cast(value, fieldType);
    }

    return _RecordResult(errors: errors, validated: validated);
  }

  dynamic _constraintValue(dynamic value, FieldType fieldType) {
    if (fieldType == FieldType.unknown ||
        fieldType == FieldType.string ||
        fieldType == FieldType.array) {
      return value;
    }
    return TypeCaster.cast(value, fieldType);
  }
}

class _RecordResult {
  final Map<String, List<String>> errors;
  final Map<String, dynamic>? validated;

  _RecordResult({required this.errors, this.validated});
}
