import 'package:eva_data_validator/i18n/validation_messages.dart';
import 'package:test/test.dart';

void main() {
  group('formatAttribute', () {
    test('strips batch index prefix', () {
      expect(formatAttribute('0.barcode'), 'barcode');
      expect(formatAttribute('12.code_rc'), 'code rc');
    });

    test('replaces underscores with spaces', () {
      expect(formatAttribute('packaging_type'), 'packaging type');
    });
  });

  group('ValidationMessages.forLocale', () {
    test('returns Russian messages for ru locale', () {
      final messages = ValidationMessages.forLocale('ru');
      expect(
        messages.required('0.barcode'),
        'Поле barcode обязательно для заполнения.',
      );
      expect(
        messages.unique('0.barcode'),
        'Такое значение barcode уже занято.',
      );
    });

    test('returns Russian messages for ru-RU locale', () {
      final messages = ValidationMessages.forLocale('ru-RU');
      expect(
        messages.integer('0.code_rc'),
        'Поле code rc должно быть целым числом.',
      );
    });

    test('falls back to English for unknown locale', () {
      final messages = ValidationMessages.forLocale('de');
      expect(
        messages.required('0.barcode'),
        'The barcode field is required.',
      );
    });

    test('returns English messages for en locale', () {
      final messages = ValidationMessages.forLocale('en');
      expect(
        messages.maxValue('0.multiplicity', 100),
        'The multiplicity must not be greater than 100.',
      );
    });
  });
}
