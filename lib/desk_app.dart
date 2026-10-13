import 'package:desk/hinge_view.dart';
import 'package:desk/ink.dart';
import 'package:desk/terminal_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DeskScrollBehavior extends MaterialScrollBehavior {
  const DeskScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class DeskApp extends StatelessWidget {
  const DeskApp({
    super.key,
    this.openHinge = false,
    this.demo = HingeDemo.rest,
  });

  final bool openHinge;
  final HingeDemo demo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'alexalghisi',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const DeskScrollBehavior(),
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: DeskInk.desk,
        fontFamily: 'monospace',
        splashFactory: NoSplash.splashFactory,
        colorScheme: const ColorScheme.dark(
          surface: DeskInk.desk,
          primary: DeskInk.amber,
        ),
      ),
      home: openHinge ? HingeView(demo: demo) : const TerminalView(),
      routes: {'/hinge': _openHinge},
    );
  }
}

Widget _openHinge(BuildContext context) {
  return const HingeView();
}
