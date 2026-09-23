import 'package:calc_web/main.dart';
import 'package:calc_web/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> openAt(WidgetTester tester, String location) async {
    await tester.pumpWidget(
      CalcApp(router: createRouter(initialLocation: location)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('прямой переход на адрес результата', (tester) async {
    await openAt(tester, '/calculator/result?a=10&op=%2F&b=3');
    expect(find.text('3.333333'), findsOneWidget);
  });

  testWidgets('деление на ноль в адресе — сообщение, а не исключение', (
    tester,
  ) async {
    await openAt(tester, '/calculator/result?a=5&op=%2F&b=0');
    expect(find.text('Деление на ноль невозможно'), findsOneWidget);
  });

  testWidgets('неизвестный адрес ведёт на 404', (tester) async {
    await openAt(tester, '/qwerty');
    expect(find.text('404'), findsOneWidget);
  });

  testWidgets('пустая форма не отправляется', (tester) async {
    await openAt(tester, '/calculator');
    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();
    expect(find.text('Введите число'), findsNWidgets(2));
    expect(find.text('Результат вычисления'), findsNothing);
  });

  testWidgets('заполненная форма переходит на результат', (tester) async {
    await openAt(tester, '/calculator');
    await tester.enterText(find.byType(TextFormField).first, '7');
    await tester.enterText(find.byType(TextFormField).last, '8');
    await tester.tap(find.text('Вычислить'));
    await tester.pumpAndSettle();
    expect(find.text('15'), findsOneWidget);
  });
}
