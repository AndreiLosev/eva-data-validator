abstract class UniqueChecker {
  Future<bool> exists({
    required String serviceId,
    required String column,
    required dynamic value,
    dynamic exceptId,
  });
}
