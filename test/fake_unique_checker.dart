import 'package:eva_data_validator/db/unique_checker.dart';

class FakeUniqueChecker implements UniqueChecker {
  final Map<String, Set<dynamic>> existing = {};
  final List<ExistsCall> calls = [];

  String _key(String serviceId, String column) => '$serviceId:$column';

  void seed(String serviceId, String column, dynamic value) {
    existing.putIfAbsent(_key(serviceId, column), () => {}).add(value);
  }

  @override
  Future<bool> exists({
    required String serviceId,
    required String column,
    required dynamic value,
    dynamic exceptId,
  }) async {
    calls.add(ExistsCall(
      serviceId: serviceId,
      column: column,
      value: value,
      exceptId: exceptId,
    ));

    final values = existing[_key(serviceId, column)] ?? {};
    if (!values.contains(value)) {
      return false;
    }
    if (exceptId != null && values.length == 1) {
      return false;
    }
    return true;
  }
}

class ExistsCall {
  final String serviceId;
  final String column;
  final dynamic value;
  final dynamic exceptId;

  ExistsCall({
    required this.serviceId,
    required this.column,
    required this.value,
    this.exceptId,
  });
}
