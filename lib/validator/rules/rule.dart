abstract class ValidationRule {
  String get name;

  /// Returns an error message or null if the value passes.
  String? validate(String attribute, dynamic value);
}

String formatAttribute(String attribute) =>
    attribute.replaceAll('_', ' ').replaceAll('.', ' ');
