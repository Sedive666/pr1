import 'package:calc_web/logic/calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double valueOf(CalcResult result) => (result as CalcSuccess).value;
  String errorOf(CalcResult result) => (result as CalcFailure).message;

  group('calculate — четыре операции', () {
    test('сложение', () => expect(valueOf(calculate('2', '+', '3')), 5));
    test('вычитание', () => expect(valueOf(calculate('2', '-', '3')), -1));
    test('умножение', () => expect(valueOf(calculate('2.5', '*', '4')), 10));
    test('деление', () => expect(valueOf(calculate('10', '/', '4')), 2.5));
    test('запятая как десятичный разделитель', () {
      expect(valueOf(calculate('1,5', '+', '2,25')), 3.75);
    });
  });

  group('calculate — ошибки', () {
    test('деление на ноль', () {
      expect(errorOf(calculate('5', '/', '0')), 'Деление на ноль невозможно');
    });
    test('первое число не число', () {
      expect(
        errorOf(calculate('abc', '+', '1')),
        contains('«a» не является числом'),
      );
    });
    test('второе число не число', () {
      expect(
        errorOf(calculate('1', '+', '2x')),
        contains('«b» не является числом'),
      );
    });
    test('NaN и Infinity не считаются числами', () {
      expect(calculate('NaN', '+', '1'), isA<CalcFailure>());
      expect(calculate('1', '*', 'Infinity'), isA<CalcFailure>());
    });
    test('неизвестная операция', () {
      expect(
        errorOf(calculate('1', '^', '2')),
        contains('Неизвестная операция'),
      );
    });
    test('плюс, пришедший из адреса пробелом, считается сложением', () {
      expect(valueOf(calculate('1', ' ', '2')), 3);
    });
    test('отсутствует параметр', () {
      expect(errorOf(calculate(null, '+', '1')), contains('«a»'));
      expect(errorOf(calculate('1', null, '1')), contains('«op»'));
      expect(errorOf(calculate('1', '+', '')), contains('«b»'));
    });
    test('переполнение', () {
      expect(calculate('1e308', '*', '10'), isA<CalcFailure>());
    });
  });

  test('выражение и результат форматируются с округлением', () {
    final result = calculate('10', '/', '3') as CalcSuccess;
    expect(result.expression, '10 ÷ 3');
    expect(result.formattedValue, '3.333333');
  });
}
