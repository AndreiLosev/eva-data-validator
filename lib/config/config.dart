import 'package:eva_data_validator/config/validation_schema.dart';
import 'package:eva_data_validator/db/unique_checker.dart';

class Config {
  final Map<String, ValidationSchema> validations;

  Config(this.validations);

  factory Config.fromMap(
    Map<dynamic, dynamic> map, {
    UniqueChecker? uniqueChecker,
  }) {
    final raw = map['validations'];
    if (raw is! Map || raw.isEmpty) {
      throw Exception('config.validations must be a non-empty map');
    }

    final validations = <String, ValidationSchema>{};
    for (final entry in raw.entries) {
      final name = entry.key.toString();
      if (validations.containsKey(name)) {
        throw Exception('duplicate validation schema: $name');
      }
      final fields = entry.value;
      if (fields is! Map) {
        throw Exception('validation $name must be a map of field rules');
      }
      validations[name] = ValidationSchema.fromMap(
        name,
        fields.cast(),
        uniqueChecker: uniqueChecker,
      );
    }

    return Config(validations);
  }

  ValidationSchema? schema(String name) => validations[name];
}
