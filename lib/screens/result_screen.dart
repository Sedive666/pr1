import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/page_scaffold.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen.success({
    super.key,
    required this.title,
    required this.params,
    required this.backPath,
    required String this.expression,
    required String this.value,
    this.details,
  }) : error = null;

  const ResultScreen.failure({
    super.key,
    required this.title,
    required this.params,
    required this.backPath,
    required String this.error,
  }) : expression = null,
       value = null,
       details = null;

  final String title;

  final Map<String, String> params;

  final String backPath;

  final String? expression;
  final String? value;
  final String? details;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isError = error != null;

    return PageScaffold(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
                    size: 56,
                    color: isError ? colors.error : colors.primary,
                  ),
                  const SizedBox(height: 16),
                  if (isError) ...[
                    Text(
                      'Не удалось выполнить',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.error,
                      ),
                    ),
                  ] else ...[
                    Text(
                      '$expression =',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      value!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (details != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        details!,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ParamsTable(params: params),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go(backPath),
            icon: const Icon(Icons.edit_outlined),
            label: Text(isError ? 'Вернуться к форме' : 'Изменить данные'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_outlined),
            label: const Text('На главную'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParamsTable extends StatelessWidget {
  const _ParamsTable({required this.params});

  final Map<String, String> params;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Параметры адреса', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            if (params.isEmpty)
              const Text('Параметры не переданы')
            else
              for (final entry in params.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${entry.key} = ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: '«${entry.value}»'),
                      ],
                    ),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
