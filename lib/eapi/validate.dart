import 'package:eva_data_validator/validator/validator_engine.dart';
import 'package:eva_sdk/eva_sdk.dart';

class Validate {
  static const name = 'validate';
  static const description = 'validate data against a named schema';

  Future<Map<String, dynamic>> call(Map<String, dynamic> params) async {
    final schemaName = params['name'];
    if (schemaName is! String || schemaName.isEmpty) {
      throw EvaError(EvaErrorKind.invalidParams, 'param name: String is required');
    }

    final data = params['data'];
    if (data is! List) {
      throw EvaError(EvaErrorKind.invalidParams, 'param data: list is required');
    }

    Map<String, String>? fieldAliases;
    if (params['field_aliases'] != null) {
      if (params['field_aliases'] is! Map) {
        throw EvaError(EvaErrorKind.invalidParams, 'param field_aliases: map is required');
      }
      fieldAliases = {};
      for (final entry in (params['field_aliases'] as Map).entries) {
        if (entry.key is String && entry.value is String) {
          fieldAliases[entry.key] = entry.value;
        }
      }
    }

    final engine = ValidatorEngine.getInstance();
    if (engine.findSchema(schemaName) == null) {
      throw EvaError(
        EvaErrorKind.invalidParams,
        'unknown validation schema: $schemaName',
      );
    }

    try {
      return (await engine.validate(schemaName, data, fieldAliases: fieldAliases)).toMap();
    } on ArgumentError catch (e) {
      throw EvaError(EvaErrorKind.invalidParams, e.message?.toString() ?? '$e');
    }
  }

  static ServiceMethod createMethod() {
    return ServiceMethod(name, Validate().call, description)
      ..required('name', 'String', 'validation schema name')
      ..required('data', 'list', 'list of records to validate')
      ..optional('field_aliases', 'map', 'optional field display names for error messages');
  }
}
