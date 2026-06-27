import 'package:eva_data_validator/validator/rule_parser.dart';
import 'package:eva_data_validator/validator/rules/between.dart';
import 'package:eva_data_validator/validator/rules/email.dart';
import 'package:eva_data_validator/validator/rules/in_rule.dart';
import 'package:eva_data_validator/validator/rules/integer_rule.dart';
import 'package:eva_data_validator/validator/rules/max.dart';
import 'package:eva_data_validator/validator/rules/min.dart';
import 'package:eva_data_validator/validator/rules/nullable.dart';
import 'package:eva_data_validator/validator/rules/required.dart';
import 'package:eva_data_validator/validator/rules/string_rule.dart';
import 'package:eva_data_validator/validator/rules/unique.dart';
import 'package:test/test.dart';

import 'fake_unique_checker.dart';

void main() {
  group('RuleParser', () {
    test('parses pipe string rules', () {
      final rules = RuleParser.parse('required|integer|min:1|max:100');
      expect(rules, hasLength(4));
      expect(rules[0], isA<RequiredRule>());
      expect(rules[1], isA<IntegerRule>());
      expect(rules[2], isA<MinRule>());
      expect(rules[3], isA<MaxRule>());
    });

    test('parses list rules', () {
      final rules = RuleParser.parse(['required', 'string', 'max:255']);
      expect(rules, hasLength(3));
      expect(rules[1], isA<StringRule>());
      expect(rules[2], isA<MaxRule>());
    });

    test('parses between, regex, in and not_in', () {
      final rules = RuleParser.parse(
        'required|between:1,10|regex:/^[a-z]+\$/|in:a,b,c|not_in:x',
      );
      expect(rules[1], isA<BetweenRule>());
      expect(rules[2].name, 'regex');
      expect(rules[3], isA<InRule>());
      expect(rules[4], isA<NotInRule>());
    });

    test('parses nullable and email', () {
      final rules = RuleParser.parse('nullable|email');
      expect(rules[0], isA<NullableRule>());
      expect(rules[1], isA<EmailRule>());
    });

    test('throws on unknown rule', () {
      expect(() => RuleParser.parse('unknown'), throwsFormatException);
    });

    test('parses unique rule with service id and column', () {
      final checker = FakeUniqueChecker();
      final rules = RuleParser.parse(
        'required|string|unique:softkip.generic.db,barcode',
        uniqueChecker: checker,
      );
      expect(rules[2], isA<UniqueRule>());
      final unique = rules[2] as UniqueRule;
      expect(unique.serviceId, 'softkip.generic.db');
      expect(unique.column, 'barcode');
      expect(unique.exceptField, isNull);
    });

    test('parses unique rule with except field', () {
      final checker = FakeUniqueChecker();
      final rules = RuleParser.parse(
        'unique:softkip.generic.db,barcode,id',
        uniqueChecker: checker,
      );
      final unique = rules.single as UniqueRule;
      expect(unique.exceptField, 'id');
    });

    test('throws when unique rule has no checker', () {
      expect(
        () => RuleParser.parse('unique:softkip.generic.db,barcode'),
        throwsFormatException,
      );
    });

    test('throws when unique rule has no params', () {
      final checker = FakeUniqueChecker();
      expect(
        () => RuleParser.parse('unique:', uniqueChecker: checker),
        throwsFormatException,
      );
    });
  });
}
