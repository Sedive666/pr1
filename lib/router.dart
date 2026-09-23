import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'logic/calculator.dart';
import 'logic/currency.dart';
import 'screens/calculator_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/home_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/result_screen.dart';

GoRouter createRouter({String initialLocation = '/'}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/calculator',
      builder: (context, state) {
        final q = state.uri.queryParameters;
        return CalculatorScreen(
          key: ValueKey(state.uri.query),
          initialA: q['a'],
          initialOp: q['op'],
          initialB: q['b'],
        );
      },
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            const title = 'Результат вычисления';
            return switch (calculate(q['a'], q['op'], q['b'])) {
              CalcSuccess(:final expression, :final formattedValue) =>
                ResultScreen.success(
                  title: title,
                  params: q,
                  backPath: Uri(
                    path: '/calculator',
                    queryParameters: q,
                  ).toString(),
                  expression: expression,
                  value: formattedValue,
                ),
              CalcFailure(:final message) => ResultScreen.failure(
                title: title,
                params: q,
                backPath: '/calculator',
                error: message,
              ),
            };
          },
        ),
      ],
    ),
    GoRoute(
      path: '/converter',
      builder: (context, state) {
        final q = state.uri.queryParameters;
        return ConverterScreen(
          key: ValueKey(state.uri.query),
          initialAmount: q['amount'],
          initialFrom: q['from'],
          initialTo: q['to'],
        );
      },
      routes: [
        GoRoute(
          path: 'result',
          builder: (context, state) {
            final q = state.uri.queryParameters;
            const title = 'Результат конвертации';
            return switch (convert(q['amount'], q['from'], q['to'])) {
              ConvertSuccess result => ResultScreen.success(
                title: title,
                params: q,
                backPath: Uri(
                  path: '/converter',
                  queryParameters: q,
                ).toString(),
                expression: result.expression,
                value: result.formattedValue,
                details: 'Курс: ${result.formattedRate}',
              ),
              ConvertFailure(:final message) => ResultScreen.failure(
                title: title,
                params: q,
                backPath: '/converter',
                error: message,
              ),
            };
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) =>
      NotFoundScreen(location: state.uri.toString()),
);

final appRouter = createRouter();
