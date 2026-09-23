import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/currency.dart';
import '../logic/number.dart';
import '../settings/app_settings.dart';
import '../widgets/page_scaffold.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({
    super.key,
    this.initialAmount,
    this.initialFrom,
    this.initialTo,
  });

  final String? initialAmount;
  final String? initialFrom;
  final String? initialTo;

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  late String _from;
  late String _to;

  @override
  void initState() {
    super.initState();
    final saved = appSettings.currencyPair;
    _from = findCurrency(widget.initialFrom)?.code ?? saved.from;
    _to = findCurrency(widget.initialTo)?.code ?? saved.to;
    if (parseNumber(widget.initialAmount) != null) {
      _amountController.text = widget.initialAmount!;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setPair(String from, String to) {
    setState(() {
      _from = from;
      _to = to;
    });
    appSettings.saveCurrencyPair(from, to);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    appSettings.saveCurrencyPair(_from, _to);
    final amount = _amountController.text.trim().replaceAll(',', '.');
    context.go('/converter/result?amount=$amount&from=$_from&to=$_to');
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Конвертер валют',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Сумма',
                hintText: 'Например, 100',
                border: OutlineInputBorder(),
              ),
              validator: validateAmount,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            _CurrencyField(
              key: ValueKey('from-$_from'),
              label: 'Из валюты',
              value: _from,
              onChanged: (code) => _setPair(code, _to),
            ),
            Center(
              child: IconButton(
                tooltip: 'Поменять местами',
                icon: const Icon(Icons.swap_vert),
                onPressed: () => _setPair(_to, _from),
              ),
            ),
            _CurrencyField(
              key: ValueKey('to-$_to'),
              label: 'В валюту',
              value: _to,
              onChanged: (code) => _setPair(_from, code),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.currency_exchange),
              label: const Text('Конвертировать'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyField extends StatelessWidget {
  const _CurrencyField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: currencies
          .map(
            (c) => DropdownMenuItem(
              value: c.code,
              child: Text(
                '${c.code} — ${c.name}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (code) {
        if (code != null) onChanged(code);
      },
    );
  }
}
