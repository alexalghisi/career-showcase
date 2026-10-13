import 'package:desk/desk_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> submit(WidgetTester tester, String command) async {
  await tester.enterText(find.byKey(const Key('command-field')), command);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> pumpSize(
  WidgetTester tester,
  Size size, {
  bool openHinge = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(DeskApp(openHinge: openHinge));
  await tester.pump();
}
