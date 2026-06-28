import 'package:eva_data_validator/config/config.dart';
import 'package:eva_data_validator/validator/validator_engine.dart';
import 'package:test/test.dart';

import 'fake_unique_checker.dart';

void main() {
  late FakeUniqueChecker checker;

  setUp(() {
    ValidatorEngine.resetForTests();
    checker = FakeUniqueChecker();
  });

  tearDown(() {
    ValidatorEngine.resetForTests();
  });

  ValidatorEngine createEngine({String locale = 'en'}) {
    return ValidatorEngine.getInstance(
      Config.fromMap(
        {
          'locale': locale,
          'validations': {
            'product': {
              'barcode': 'required|string',
              'multiplicity': 'required|integer|min:1|max:100',
              'packaging_type': 'nullable|string',
            },
            'sensor_reading': {
              'value': 'required|numeric|min:0',
              'active': 'required|boolean',
            },
            'optional_note': {
              'note': 'sometimes|string|max:10',
            },
            'product_unique': {
              'barcode': 'required|string|unique:softkip.generic.db,barcode',
              'id': 'sometimes|integer',
            },
            'product_update': {
              'barcode':
                  'required|string|unique:softkip.generic.db,barcode,id',
              'id': 'required|integer',
            },
          },
        },
        uniqueChecker: checker,
      ),
    );
  }

  group('ValidatorEngine en', () {
    late ValidatorEngine engine;

    setUp(() {
      engine = createEngine();
    });

    test('casts string integers and returns validated fields only', () async {
      final result = await engine.validate('product', [
        {
          'barcode': '123',
          'multiplicity': '5',
          'packaging_type': null,
        },
      ]);

      expect(result.valid, isTrue);
      expect(result.data, [
        {
          'barcode': '123',
          'multiplicity': 5,
          'packaging_type': null,
        },
      ]);
    });

    test('returns required errors', () async {
      final result = await engine.validate('product', [
        {'multiplicity': '5'},
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.barcode'], [
        'The barcode field is required.',
      ]);
    });

    test('returns type and range errors', () async {
      final result = await engine.validate('product', [
        {
          'barcode': '123',
          'multiplicity': 'abc',
        },
        {
          'barcode': '456',
          'multiplicity': '200',
        },
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.multiplicity'], [
        'The multiplicity must be an integer.',
      ]);
      expect(result.errors?['1.multiplicity'], [
        'The multiplicity must not be greater than 100.',
      ]);
    });

    test('casts numeric and boolean values', () async {
      final result = await engine.validate('sensor_reading', [
        {'value': '12.5', 'active': 'true'},
      ]);

      expect(result.valid, isTrue);
      expect(result.data, [
        {'value': 12.5, 'active': true},
      ]);
    });

    test('skips sometimes fields when absent', () async {
      final result = await engine.validate('optional_note', [
        {},
      ]);

      expect(result.valid, isTrue);
      expect(result.data, [{}]);
    });

    test('validates sometimes fields when present', () async {
      final result = await engine.validate('optional_note', [
        {'note': 'this is too long'},
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.note'], isNotEmpty);
    });

    test('returns unique error when value already exists', () async {
      checker.seed('softkip.generic.db', 'barcode', '123');

      final result = await engine.validate('product_unique', [
        {'barcode': '123'},
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.barcode'], [
        'The barcode has already been taken.',
      ]);
    });

    test('passes unique check when value is available', () async {
      final result = await engine.validate('product_unique', [
        {'barcode': '999'},
      ]);

      expect(result.valid, isTrue);
      expect(result.data, [
        {'barcode': '999'},
      ]);
    });

    test('passes unique update when except id is provided', () async {
      checker.seed('softkip.generic.db', 'barcode', '123');

      final result = await engine.validate('product_update', [
        {'barcode': '123', 'id': 5},
      ]);

      expect(result.valid, isTrue);
      expect(checker.calls.last.exceptId, 5);
    });

    test('throws for unknown schema', () async {
      expect(
        () => engine.validate('missing', []),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when record is not a dict', () async {
      expect(
        () => engine.validate('product', ['not-a-map']),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('ValidatorEngine ru', () {
    late ValidatorEngine engine;

    setUp(() {
      engine = createEngine(locale: 'ru');
    });

    test('returns required errors in Russian', () async {
      final result = await engine.validate('product', [
        {'multiplicity': '5'},
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.barcode'], [
        'Поле barcode обязательно для заполнения.',
      ]);
    });

    test('returns unique error in Russian', () async {
      checker.seed('softkip.generic.db', 'barcode', '123');

      final result = await engine.validate('product_unique', [
        {'barcode': '123'},
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.barcode'], [
        'Такое значение barcode уже занято.',
      ]);
    });
  });
}
