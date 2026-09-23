import 'package:calc_web/logic/currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('валют не меньше пяти, коды уникальны', () {
    expect(currencies.length, greaterThanOrEqualTo(5));
    expect(currencies.map((c) => c.code).toSet().length, currencies.length);
  });

  test('конвертация USD → RUB', () {
    final result = convert('100', 'USD', 'RUB') as ConvertSuccess;
    expect(result.value, closeTo(8150, 1e-9));
    expect(result.formattedValue, '8150.00 RUB');
  });

  test('обратная конвертация возвращает исходную сумму', () {
    final there = convert('250', 'EUR', 'CNY') as ConvertSuccess;
    final back = convert('${there.value}', 'CNY', 'EUR') as ConvertSuccess;
    expect(back.value, closeTo(250, 1e-9));
  });

  test('одинаковые валюты — сумма не меняется', () {
    expect((convert('42.5', 'GBP', 'GBP') as ConvertSuccess).value, 42.5);
  });

  test('код валюты не зависит от регистра', () {
    expect(convert('1', 'usd', 'eur'), isA<ConvertSuccess>());
  });

  group('ошибки', () {
    String errorOf(ConvertResult result) => (result as ConvertFailure).message;

    test('сумма не число', () {
      expect(
        errorOf(convert('сто', 'USD', 'RUB')),
        contains('не является числом'),
      );
    });
    test('отрицательная сумма', () {
      expect(errorOf(convert('-5', 'USD', 'RUB')), contains('отрицательной'));
    });
    test('неизвестная валюта', () {
      expect(
        errorOf(convert('1', 'XYZ', 'RUB')),
        contains('Неизвестная валюта'),
      );
    });
    test('отсутствует параметр', () {
      expect(errorOf(convert(null, 'USD', 'RUB')), contains('«amount»'));
      expect(errorOf(convert('1', null, 'RUB')), contains('«from»'));
      expect(errorOf(convert('1', 'USD', null)), contains('«to»'));
    });
  });
}
