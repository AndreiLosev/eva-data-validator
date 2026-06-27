import 'package:eva_data_validator/config/config.dart';
import 'package:eva_data_validator/validator/validator_engine.dart';
import 'package:test/test.dart';

void main() {
  late ValidatorEngine engine;

  setUp(() {
    ValidatorEngine.resetForTests();
    engine = ValidatorEngine.getInstance(
      Config.fromMap({
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
        },
      }),
    );
  });

  tearDown(() {
    ValidatorEngine.resetForTests();
  });

  group('ValidatorEngine', () {
    test('casts string integers and returns validated fields only', () {
      final result = engine.validate('product', [
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

    test('returns required errors with batch index prefix', () {
      final result = engine.validate('product', [
        {'multiplicity': '5'},
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.barcode'], [
        'The 0 barcode field is required.',
      ]);
    });

    test('returns type and range errors', () {
      final result = engine.validate('product', [
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
        'The 0 multiplicity must be an integer.',
      ]);
      expect(result.errors?['1.multiplicity'], [
        'The 1 multiplicity must not be greater than 100.',
      ]);
    });

    test('casts numeric and boolean values', () {
      final result = engine.validate('sensor_reading', [
        {'value': '12.5', 'active': 'true'},
      ]);

      expect(result.valid, isTrue);
      expect(result.data, [
        {'value': 12.5, 'active': true},
      ]);
    });

    test('skips sometimes fields when absent', () {
      final result = engine.validate('optional_note', [
        {},
      ]);

      expect(result.valid, isTrue);
      expect(result.data, [{}]);
    });

    test('validates sometimes fields when present', () {
      final result = engine.validate('optional_note', [
        {'note': 'this is too long'},
      ]);

      expect(result.valid, isFalse);
      expect(result.errors?['0.note'], isNotEmpty);
    });

    test('throws for unknown schema', () {
      expect(
        () => engine.validate('missing', []),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when record is not a dict', () {
      expect(
        () => engine.validate('product', ['not-a-map']),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
