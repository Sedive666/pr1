import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/number.dart';
import '../widgets/page_scaffold.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({
    super.key,
    this.initialA,
    this.initialOp,
    this.initialB,
  });

  final String? initialA;
  final String? initialOp;
  final String? initialB;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  String _operation = '+';

  @override
  void initState() {
    super.initState();
    if (parseNumber(widget.initialA) != null) {
      _aController.text = widget.initialA!;
    }
    if (parseNumber(widget.initialB) != null) {
      _bController.text = widget.initialB!;
    }
    _operation = normalizeOperation(widget.initialOp) ?? '+';
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final a = _aController.text.trim().replaceAll(',', '.');
    final b = _bController.text.trim().replaceAll(',', '.');
    context.go(
      '/calculator/result'
      '?a=$a&op=${Uri.encodeComponent(_operation)}&b=$b',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Калькулятор',
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _NumberField(
              controller: _aController,
              label: 'Первое число',
              onSubmitted: _submit,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _operation,
              decoration: const InputDecoration(
                labelText: 'Операция',
                border: OutlineInputBorder(),
              ),
              items: calcOperations
                  .map(
                    (op) => DropdownMenuItem(
                      value: op,
                      child: Text(
                        '${operationSymbol(op)}   ${operationName(op)}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _operation = value ?? '+'),
            ),
            const SizedBox(height: 16),
            _NumberField(
              controller: _bController,
              label: 'Второе число',
              onSubmitted: _submit,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Вычислить'),
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

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Например, 12.5',
        border: const OutlineInputBorder(),
      ),
      validator: validateNumber,
      onFieldSubmitted: (_) => onSubmitted(),
    );
  }
}
