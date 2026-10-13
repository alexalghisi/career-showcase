import 'package:desk/desk_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/journey.dart';

void main() {
  testWidgets('from the prompt, through the sheet, and back to contact', (
    tester,
  ) async {
    await tester.pumpWidget(const DeskApp());

    await submit(tester, 'education');
    expect(
      find.textContaining('Technical University of Cluj-Napoca'),
      findsWidgets,
    );

    await submit(tester, 'projects');
    expect(find.textContaining('github.com/alexalghisi/collab'), findsWidgets);

    await submit(tester, 'hinge');
    expect(find.byKey(const Key('hinge-stage')), findsOneWidget);
    expect(find.text('Raw Geeks'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('role-Complaion')));
    await tester.pump();
    expect(find.textContaining('FastAPI'), findsWidgets);

    await tester.drag(find.byKey(const Key('pin-a')), const Offset(-30, 24));
    await tester.pump();
    expect(find.text('scale 1.00    fold 0.00'), findsNothing);

    await tester.tap(find.byKey(const Key('reset-pins')));
    await tester.pump();
    expect(find.text('scale 1.00    fold 0.00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('back-to-desk')));
    await tester.pumpAndSettle();

    await submit(tester, 'contact');
    expect(find.textContaining('linkedin.com/in/alghisi'), findsWidgets);
    expect(find.textContaining('github.com/alexalghisi'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
