import 'number.dart';

class Currency {
  final String code;
  final String name;

  final double rateToRub;

  const Currency(this.code, this.name, this.rateToRub);
}

const currencies = [
  Currency('RUB', 'Российский рубль', 1),
  Currency('USD', 'Доллар США', 81.5),
  Currency('EUR', 'Евро', 94.8),
  Currency('CNY', 'Китайский юань', 11.4),
  Currency('GBP', 'Фунт стерлингов', 109.6),
  Currency('JPY', 'Японская иена', 0.55),
];

const defaultFrom = 'USD';
const defaultTo = 'RUB';

Currency? findCurrency(String? code) {
  if (code == null) return null;
  final normalized = code.trim().toUpperCase();
  for (final currency in currencies) {
    if (currency.code == normalized) return currency;
  }
  return null;
}

sealed class ConvertResult {
  const ConvertResult();
}

class ConvertSuccess extends ConvertResult {
  final double amount;
  final Currency from;
  final Currency to;
  final double value;
  const ConvertSuccess(this.amount, this.from, this.to, this.value);

  double get rate => from.rateToRub / to.rateToRub;

  String get expression => '${formatMoney(amount)} ${from.code}';
  String get formattedValue => '${formatMoney(value)} ${to.code}';
  String get formattedRate =>
      '1 ${from.code} = ${formatNumber(rate, maxFractionDigits: 4)} ${to.code}';
}

class ConvertFailure extends ConvertResult {
  final String message;
  const ConvertFailure(this.message);
}

ConvertResult convert(String? rawAmount, String? rawFrom, String? rawTo) {
  if (rawAmount == null || rawAmount.trim().isEmpty) {
    return const ConvertFailure('Не передан параметр «amount» — сумма');
  }
  if (rawFrom == null || rawFrom.trim().isEmpty) {
    return const ConvertFailure('Не передан параметр «from» — исходная валюта');
  }
  if (rawTo == null || rawTo.trim().isEmpty) {
    return const ConvertFailure('Не передан параметр «to» — целевая валюта');
  }

  final amount = parseNumber(rawAmount);
  if (amount == null) {
    return ConvertFailure('Параметр «amount» не является числом: «$rawAmount»');
  }
  if (amount < 0) {
    return const ConvertFailure('Сумма не может быть отрицательной');
  }
  final from = findCurrency(rawFrom);
  if (from == null) return ConvertFailure('Неизвестная валюта «$rawFrom»');
  final to = findCurrency(rawTo);
  if (to == null) return ConvertFailure('Неизвестная валюта «$rawTo»');

  final value = amount * from.rateToRub / to.rateToRub;
  if (!value.isFinite) {
    return const ConvertFailure('Сумма слишком большая для конвертации');
  }
  return ConvertSuccess(amount, from, to, value);
}
