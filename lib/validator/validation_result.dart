class ValidationResult {
  final bool valid;
  final List<Map<String, dynamic>>? data;
  final Map<String, List<String>>? errors;

  const ValidationResult._({
    required this.valid,
    this.data,
    this.errors,
  });

  factory ValidationResult.success(List<Map<String, dynamic>> data) =>
      ValidationResult._(valid: true, data: data);

  factory ValidationResult.failure(Map<String, List<String>> errors) =>
      ValidationResult._(valid: false, errors: errors);

  Map<String, dynamic> toMap() {
    if (valid) {
      return {'valid': true, 'data': data};
    }
    return {'valid': false, 'errors': errors};
  }
}
