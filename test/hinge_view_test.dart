import 'package:desk/desk_app.dart';
import 'package:desk/hinge_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/journey.dart';

void main() {
  testWidgets('the sheet opens on the newest role, flat', (tester) async {
    await tester.pumpWidget(const DeskApp(openHinge: true));
    await tester.pump();

    expect(find.byKey(const Key('sheet-front')), findsOneWidget);
    expect(find.text('Raw Geeks'), findsWidgets);
    expect(find.text('scale 1.00    fold 0.00'), findsOneWidget);
  });

  testWidgets('dragging a pin changes the readout and reset restores it', (
    tester,
  ) async {
    await tester.pumpWidget(const DeskApp(openHinge: true));
    await tester.pump();

    await tester.drag(find.byKey(const Key('pin-b')), const Offset(90, -50));
    await tester.pump();
    expect(find.text('scale 1.00    fold 0.00'), findsNothing);

    await tester.tap(find.byKey(const Key('reset-pins')));
    await tester.pump();
    expect(find.text('scale 1.00    fold 0.00'), findsOneWidget);
  });

  testWidgets('a turned pose is already folded', (tester) async {
    await tester.pumpWidget(
      const DeskApp(openHinge: true, demo: HingeDemo.turned),
    );
    await tester.pump();

    expect(find.text('scale 1.00    fold 0.00'), findsNothing);
    expect(find.byKey(const Key('sheet-front')), findsOneWidget);
  });

  testWidgets('picking a role reprints that role on the sheet', (tester) async {
    await tester.pumpWidget(const DeskApp(openHinge: true));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('role-Hewlett Packard Enterprise')),
      80,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(
      find.byKey(const ValueKey('role-Hewlett Packard Enterprise')),
    );
    await tester.pump();

    expect(find.textContaining('LoadRunner'), findsWidgets);
    expect(find.text('2017  Hewlett Packard Enterprise'), findsOneWidget);
  });

  testWidgets('back from the command returns to the prompt', (tester) async {
    await tester.pumpWidget(const DeskApp());
    await submit(tester, 'hinge');

    expect(find.byKey(const Key('hinge-stage')), findsOneWidget);
    await tester.tap(find.byKey(const Key('back-to-desk')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('prompt')), findsOneWidget);
    expect(find.textContaining('opening the sheet.'), findsOneWidget);
  });

  testWidgets('the sheet lays out on a phone and on a wide desk', (
    tester,
  ) async {
    await pumpSize(tester, const Size(390, 844), openHinge: true);
    expect(find.byKey(const Key('pin-a')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await pumpSize(tester, const Size(1440, 900), openHinge: true);
    expect(find.byKey(const Key('pin-b')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
