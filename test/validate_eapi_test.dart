import 'package:eva_data_validator/config/config.dart';
import 'package:eva_data_validator/eapi/validate.dart';
import 'package:eva_data_validator/validator/validator_engine.dart';
import 'package:eva_sdk/eva_sdk.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() async {
    ValidatorEngine.resetForTests();
    ValidatorEngine.getInstance(
      Config.fromMap({
        'validations': {
          'product': {
            'barcode': 'required|string',
          },
        },
      }),
    );
  });

  tearDownAll(() {
    ValidatorEngine.resetForTests();
  });

  group('Validate eapi', () {
    test('createMethod exposes rpc metadata', () {
      final method = Validate.createMethod();
      expect(method.name, 'validate');
      expect(method.getRequared(), containsAll(['name', 'data']));
    });

    test('returns validation result map for valid data', () async {
      final result = await Validate().call({
        'name': 'product',
        'data': [
          {'barcode': '123'},
        ],
      });

      expect(result['valid'], isTrue);
      expect(result['data'], [
        {'barcode': '123'},
      ]);
    });

    test('throws EvaError for unknown schema', () async {
      expect(
        () => Validate().call({
          'name': 'unknown',
          'data': [],
        }),
        throwsA(isA<EvaError>()),
      );
    });

    test('throws EvaError for invalid params', () async {
      expect(
        () => Validate().call({'data': []}),
        throwsA(isA<EvaError>()),
      );
      expect(
        () => Validate().call({'name': 'product', 'data': 'bad'}),
        throwsA(isA<EvaError>()),
      );
    });
  });
}
