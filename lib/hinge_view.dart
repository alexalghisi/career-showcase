import 'dart:math' as math;

import 'package:desk/hinge_math.dart';
import 'package:desk/ink.dart';
import 'package:desk/profile.dart';
import 'package:desk/terminal_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum HingeDemo { rest, turned }

class HingeView extends StatefulWidget {
  const HingeView({super.key, this.demo = HingeDemo.rest});

  final HingeDemo demo;

  @override
  State<HingeView> createState() => _HingeViewState();
}

class _HingeViewState extends State<HingeView> {
  var _index = 0;
  Size? _stage;
  Offset? _restA;
  Offset? _restB;
  Offset? _liveA;
  Offset? _liveB;

  void _place(Size stage) {
    if (_stage == stage && _restA != null) {
      return;
    }
    final first = _restA == null;
    final mid = Offset(stage.width / 2, stage.height / 2);
    final half = math.min(110.0, stage.width * 0.18);
    if (first) {
      _restA = mid + Offset(-half, 0);
      _restB = mid + Offset(half, 0);
      if (widget.demo == HingeDemo.turned) {
        _liveA = clampPin(mid + const Offset(-64, 28), stage);
        _liveB = clampPin(mid + const Offset(150, -96), stage);
      } else {
        _liveA = _restA;
        _liveB = _restB;
      }
    } else {
      _liveA = clampPin(_liveA!, stage);
      _liveB = clampPin(_liveB!, stage);
    }
    _stage = stage;
  }

  void _drag(bool leading, Offset delta) {
    final stage = _stage;
    if (stage == null) {
      return;
    }
    setState(() {
      if (leading) {
        _liveA = clampPin(_liveA! + delta, stage);
      } else {
        _liveB = clampPin(_liveB! + delta, stage);
      }
    });
  }

  void _reset() {
    setState(() {
      _liveA = _restA;
      _liveB = _restB;
    });
  }

  void _back() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    navigator.pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const TerminalView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = profile.roles[_index];
    return Scaffold(
      backgroundColor: DeskInk.desk,
      body: SafeArea(
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): _back,
            const SingleActivator(LogicalKeyboardKey.keyR): _reset,
          },
          child: Focus(
            autofocus: true,
            child: Column(
              children: [
                _bar(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 720;
                      final rail = _rail(wide);
                      final stage = Expanded(child: _stageColumn());
                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(width: 280, child: rail),
                            stage,
                          ],
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(height: 168, child: rail),
                          stage,
                        ],
                      );
                    },
                  ),
                ),
                _footer(role),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Row(
        children: [
          TextButton(
            key: const Key('back-to-desk'),
            onPressed: _back,
            child: const Text(
              'back',
              style: TextStyle(fontFamily: 'monospace', color: DeskInk.amber),
            ),
          ),
          const Expanded(
            child: Text(
              'hinge',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                color: DeskInk.bone,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            key: const Key('reset-pins'),
            onPressed: _reset,
            child: const Text(
              'reset',
              style: TextStyle(fontFamily: 'monospace', color: DeskInk.moss),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rail(bool wide) {
    return ColoredBox(
      color: DeskInk.rail,
      child: ListView.builder(
        scrollDirection: wide ? Axis.vertical : Axis.horizontal,
        itemCount: profile.roles.length,
        itemBuilder: (context, index) {
          final role = profile.roles[index];
          final selected = index == _index;
          return InkWell(
            key: ValueKey('role-${role.org}'),
            onTap: () => setState(() => _index = index),
            child: Container(
              width: wide ? double.infinity : 168,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: selected ? const Color(0xFF2A2418) : DeskInk.rail,
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 28,
                    color: selected ? DeskInk.brass : const Color(0x00000000),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          role.span,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: DeskInk.dim,
                          ),
                        ),
                        Text(
                          role.org,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13.5,
                            color: DeskInk.bone,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _stageColumn() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stage = constraints.biggest;
        if (stage.width < 40 || stage.height < 40) {
          return const SizedBox.shrink();
        }
        _place(stage);
        final pose = solveHinge(
          restA: _restA!,
          restB: _restB!,
          liveA: _liveA!,
          liveB: _liveB!,
        );
        final sheet = sheetSizeFor(stage);
        final matrix = sheetMatrix(pose: pose, sheet: sheet);
        final role = profile.roles[_index];
        return Stack(
          key: const Key('hinge-stage'),
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(child: ColoredBox(color: DeskInk.stage)),
            Positioned(
              left: 0,
              top: 0,
              child: Transform(
                transform: matrix,
                child: SizedBox(
                  width: sheet.width,
                  height: sheet.height,
                  child: _SheetFace(role: role, back: pose.fold >= 0.5),
                ),
              ),
            ),
            _pin('pin-a', _liveA!, (delta) => _drag(true, delta)),
            _pin('pin-b', _liveB!, (delta) => _drag(false, delta)),
            Positioned(
              left: 16,
              bottom: 12,
              child: Text(
                hingeReadout(pose),
                key: const Key('hinge-readout'),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: DeskInk.dim,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _footer(Role role) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${role.span}  ${role.org}',
          key: const Key('hinge-role'),
          style: const TextStyle(
            fontFamily: 'monospace',
            color: DeskInk.bone,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _pin(String name, Offset at, ValueChanged<Offset> move) {
    const radius = 16.0;
    return Positioned(
      left: at.dx - radius,
      top: at.dy - radius,
      child: GestureDetector(
        key: Key(name),
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) => move(details.delta),
        child: Semantics(
          button: true,
          label: name,
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DeskInk.brass,
              border: Border.all(color: DeskInk.paper, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetFace extends StatelessWidget {
  const _SheetFace({required this.role, required this.back});

  final Role role;
  final bool back;

  @override
  Widget build(BuildContext context) {
    final body = back ? role.tools.join('\n') : role.lines.join('\n');
    return DecoratedBox(
      key: Key(back ? 'sheet-back' : 'sheet-front'),
      decoration: const BoxDecoration(color: DeskInk.paper),
      child: CustomPaint(
        painter: const _RulesPainter(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 28, 22, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                back ? 'tools' : role.span,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 13,
                  color: Color(0xFF8A8172),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role.org,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 28,
                  height: 1.1,
                  color: DeskInk.ink,
                ),
              ),
              if (!back) ...[
                const SizedBox(height: 6),
                Text(
                  role.title,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF3E3830),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Text(
                body,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 15,
                  height: 1.45,
                  color: DeskInk.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RulesPainter extends CustomPainter {
  const _RulesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rule = Paint()
      ..color = DeskInk.rule
      ..strokeWidth = 1;
    for (var y = 86.0; y < size.height - 18; y += 28) {
      canvas.drawLine(Offset(28, y), Offset(size.width - 18, y), rule);
    }
    canvas.drawLine(
      const Offset(32, 12),
      Offset(32, size.height - 12),
      Paint()
        ..color = DeskInk.margin
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
