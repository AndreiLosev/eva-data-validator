import 'package:eva_data_validator/validator/rules/rule.dart';

/// Marker rule — handled by the engine before other rules run.
class NullableRule extends ValidationRule {
  @override
  String get name => 'nullable';

  @override
  String? validate(String attribute, dynamic value) => null;
}
