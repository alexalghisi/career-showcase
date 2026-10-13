import 'package:desk/desk_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the desk opens on about_me.txt', (tester) async {
    await tester.pumpWidget(const DeskApp());

    expect(find.textContaining('Alghisi Alessandro Paolo'), findsOneWidget);
    expect(find.textContaining('cat about_me.txt'), findsOneWidget);
    expect(find.byKey(const Key('prompt')), findsOneWidget);
    expect(find.textContaining('# whoami'), findsOneWidget);
  });

  testWidgets('experience appends Sector Labs under a new prompt', (
    tester,
  ) async {
    await tester.pumpWidget(const DeskApp());
    await _type(tester, 'experience');

    expect(find.textContaining('Sector Labs'), findsWidgets);
    expect(
      find.textContaining('alexalghisi@cluj:~\$ experience'),
      findsOneWidget,
    );
  });

  testWidgets('an unknown command is visible as an error', (tester) async {
    await tester.pumpWidget(const DeskApp());
    await _type(tester, 'foobar');

    expect(find.textContaining('no such command'), findsOneWidget);
  });

  testWidgets('clear removes the boot file', (tester) async {
    await tester.pumpWidget(const DeskApp());
    await _type(tester, 'clear');

    expect(find.textContaining('cat about_me.txt'), findsNothing);
    expect(find.byKey(const Key('prompt')), findsOneWidget);
  });

  testWidgets('arrow up recalls the previous command', (tester) async {
    await tester.pumpWidget(const DeskApp());
    await _type(tester, 'awards');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();

    final field = tester.widget<TextField>(
      find.byKey(const Key('command-field')),
    );
    expect(field.controller?.text, 'awards');
  });

  testWidgets('narrow and wide desks both lay out', (tester) async {
    await _pumpSize(tester, const Size(390, 844));
    expect(tester.takeException(), isNull);

    await _pumpSize(tester, const Size(1440, 900));
    expect(find.textContaining('Complaion'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _type(WidgetTester tester, String command) async {
  await tester.enterText(find.byKey(const Key('command-field')), command);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> _pumpSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const DeskApp());
  await tester.pump();
}
