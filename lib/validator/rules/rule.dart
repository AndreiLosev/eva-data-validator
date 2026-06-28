import 'package:eva_data_validator/i18n/validation_messages.dart';

abstract class ValidationRule {
  String get name;

  /// Returns an error message or null if the value passes.
  String? validate(
    String attribute,
    dynamic value,
    ValidationMessages messages,
  );
}
