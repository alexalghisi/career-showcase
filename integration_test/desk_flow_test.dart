import 'package:desk/desk_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/journey.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the desk still answers after a full pass', (tester) async {
    await tester.pumpWidget(const DeskApp());
    await tester.pumpAndSettle();

    await submit(tester, 'whoami');
    expect(find.textContaining('Alghisi Alessandro Paolo'), findsWidgets);

    await submit(tester, 'hinge');
    expect(find.byKey(const Key('hinge-stage')), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('role-Google Chrome')),
      80,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('role-Google Chrome')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Pinch-to-zoom'), findsWidgets);

    await tester.tap(find.byKey(const Key('back-to-desk')));
    await tester.pumpAndSettle();

    await submit(tester, 'awards');
    expect(find.textContaining('2013 and 2014'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
