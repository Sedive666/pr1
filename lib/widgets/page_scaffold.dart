import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../settings/app_settings.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.maxWidth = 440,
    this.showHomeButton = true,
  });

  final String title;
  final Widget child;
  final double maxWidth;
  final bool showHomeButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (showHomeButton)
            IconButton(
              tooltip: 'На главную',
              icon: const Icon(Icons.home_outlined),
              onPressed: () => context.go('/'),
            ),
          const ThemeToggleButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () =>
          appSettings.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
    );
  }
}
