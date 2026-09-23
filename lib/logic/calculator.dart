import 'number.dart';

const calcOperations = ['+', '-', '*', '/'];

String? normalizeOperation(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  final op = raw == ' ' ? '+' : raw.trim();
  return calcOperations.contains(op) ? op : null;
}

String operationSymbol(String op) => switch (op) {
  '-' => '−',
  '*' => '×',
  '/' => '÷',
  _ => op,
};

String operationName(String op) => switch (op) {
  '+' => 'Сложение',
  '-' => 'Вычитание',
  '*' => 'Умножение',
  '/' => 'Деление',
  _ => op,
};

sealed class CalcResult {
  const CalcResult();
}

class CalcSuccess extends CalcResult {
  final double a;
  final String op;
  final double b;
  final double value;
  const CalcSuccess(this.a, this.op, this.b, this.value);

  String get expression =>
      '${formatNumber(a)} ${operationSymbol(op)} ${formatNumber(b)}';

  String get formattedValue => formatNumber(value);
}

class CalcFailure extends CalcResult {
  final String message;
  const CalcFailure(this.message);
}

CalcResult calculate(String? rawA, String? rawOp, String? rawB) {
  if (rawA == null || rawA.trim().isEmpty) {
    return const CalcFailure('Не передан параметр «a» — первое число');
  }
  if (rawOp == null || rawOp.isEmpty) {
    return const CalcFailure('Не передан параметр «op» — операция');
  }
  if (rawB == null || rawB.trim().isEmpty) {
    return const CalcFailure('Не передан параметр «b» — второе число');
  }

  final op = normalizeOperation(rawOp);
  if (op == null) return CalcFailure('Неизвестная операция «$rawOp»');

  final a = parseNumber(rawA);
  if (a == null) return CalcFailure('Параметр «a» не является числом: «$rawA»');
  final b = parseNumber(rawB);
  if (b == null) return CalcFailure('Параметр «b» не является числом: «$rawB»');

  if (op == '/' && b == 0) {
    return const CalcFailure('Деление на ноль невозможно');
  }
  final value = switch (op) {
    '+' => a + b,
    '-' => a - b,
    '*' => a * b,
    _ => a / b,
  };
  if (!value.isFinite) {
    return const CalcFailure('Результат слишком большой для вычисления');
  }
  return CalcSuccess(a, op, b, value);
}
