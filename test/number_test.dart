import 'package:calc_web/logic/number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatNumber — округление', () {
    test('бесконечная дробь обрезается', () {
      expect(formatNumber(10 / 3), '3.333333');
    });
    test('погрешность двоичной арифметики скрыта', () {
      expect(formatNumber(0.1 + 0.2), '0.3');
    });
    test('целое число выводится без дробной части', () {
      expect(formatNumber(5.0), '5');
    });
    test('минус ноль выводится как ноль', () {
      expect(formatNumber(-0.0000001), '0');
    });
    test('денежная сумма — два знака', () {
      expect(formatMoney(1234.5678), '1234.57');
    });
  });

  group('parseNumber и валидаторы', () {
    test('разбор чисел', () {
      expect(parseNumber(' 12,5 '), 12.5);
      expect(parseNumber('-3'), -3);
      expect(parseNumber(''), isNull);
      expect(parseNumber('12a'), isNull);
      expect(parseNumber(null), isNull);
    });
    test('валидатор числа', () {
      expect(validateNumber(''), 'Введите число');
      expect(validateNumber('   '), 'Введите число');
      expect(validateNumber('abc'), 'Это не число');
      expect(validateNumber('7'), isNull);
    });
    test('валидатор суммы запрещает отрицательные значения', () {
      expect(validateAmount('-1'), 'Сумма не может быть отрицательной');
      expect(validateAmount('0'), isNull);
    });
  });
}
