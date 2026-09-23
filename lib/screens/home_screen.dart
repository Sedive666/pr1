import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/page_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ToolCard(
        icon: Icons.calculate_outlined,
        title: 'Калькулятор',
        subtitle: 'Сложение, вычитание, умножение и деление двух чисел',
        onTap: () => context.go('/calculator'),
      ),
      _ToolCard(
        icon: Icons.currency_exchange,
        title: 'Конвертер валют',
        subtitle: 'Перевод суммы между шестью валютами по фиксированному курсу',
        onTap: () => context.go('/converter'),
      ),
    ];

    return PageScaffold(
      title: 'Главная',
      showHomeButton: false,
      maxWidth: 760,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Выберите инструмент',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth >= 560
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: cards[0]),
                        const SizedBox(width: 16),
                        Expanded(child: cards[1]),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [cards[0], const SizedBox(height: 16), cards[1]],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card.filled(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 48, color: colors.primary),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onTap, child: const Text('Открыть')),
            ],
          ),
        ),
      ),
    );
  }
}
