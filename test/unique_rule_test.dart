import 'package:eva_data_validator/validator/rules/unique.dart';
import 'package:test/test.dart';

import 'fake_unique_checker.dart';

void main() {
  late FakeUniqueChecker checker;
  late UniqueRule rule;

  setUp(() {
    checker = FakeUniqueChecker();
    rule = UniqueRule(
      serviceId: 'softkip.generic.db',
      column: 'barcode',
      checker: checker,
    );
  });

  group('UniqueRule', () {
    test('passes when value is not taken', () async {
      final message = await rule.validateAsync('0.barcode', '123', {});
      expect(message, isNull);
      expect(checker.calls, hasLength(1));
      expect(checker.calls.first.exceptId, isNull);
    });

    test('fails when value is taken', () async {
      checker.seed('softkip.generic.db', 'barcode', '123');

      final message = await rule.validateAsync('0.barcode', '123', {});
      expect(message, 'The 0 barcode has already been taken.');
    });

    test('passes update when except id matches existing row', () async {
      rule = UniqueRule(
        serviceId: 'softkip.generic.db',
        column: 'barcode',
        exceptField: 'id',
        checker: checker,
      );
      checker.seed('softkip.generic.db', 'barcode', '123');

      final message = await rule.validateAsync('0.barcode', '123', {'id': 5});
      expect(message, isNull);
      expect(checker.calls.first.exceptId, 5);
    });

    test('skips except when field is absent', () async {
      rule = UniqueRule(
        serviceId: 'softkip.generic.db',
        column: 'barcode',
        exceptField: 'id',
        checker: checker,
      );
      checker.seed('softkip.generic.db', 'barcode', '123');

      final message = await rule.validateAsync('0.barcode', '123', {});
      expect(message, isNotNull);
      expect(checker.calls.first.exceptId, isNull);
    });
  });
}
