double? parseNumber(String? raw) {
  if (raw == null) return null;
  final value = double.tryParse(raw.trim().replaceAll(',', '.'));
  if (value == null || !value.isFinite) return null;
  return value;
}

String? validateNumber(String? value) {
  if (value == null || value.trim().isEmpty) return 'Введите число';
  if (parseNumber(value) == null) return 'Это не число';
  return null;
}

String? validateAmount(String? value) {
  final error = validateNumber(value);
  if (error != null) return error;
  if (parseNumber(value)! < 0) return 'Сумма не может быть отрицательной';
  return null;
}

String formatNumber(double value, {int maxFractionDigits = 6}) {
  var text = value.toStringAsFixed(maxFractionDigits);
  if (text.contains('e')) return value.toString();
  if (text.contains('.')) text = text.replaceFirst(RegExp(r'\.?0+$'), '');
  return text == '-0' ? '0' : text;
}

String formatMoney(double value) {
  final text = value.toStringAsFixed(2);
  return text == '-0.00' ? '0.00' : text;
}
