import 'dart:math' as math;

import 'package:desk/hinge_math.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const restA = Offset(100, 200);
  const restB = Offset(300, 200);
  const sheet = Size(200, 400);

  test('pins that have not moved leave the sheet where it was', () {
    final pose = solveHinge(
      restA: restA,
      restB: restB,
      liveA: restA,
      liveB: restB,
    );
    expect(pose.scale, 1);
    expect(pose.rotation, 0);
    expect(pose.fold, 0);
    expect(pose.anchor, const Offset(200, 200));

    final center = mapSheetPoint(
      matrix: sheetMatrix(pose: pose, sheet: sheet),
      local: const Offset(100, 200),
    );
    expect(center.dx, closeTo(200, 0.001));
    expect(center.dy, closeTo(200, 0.001));
    expect(hingeReadout(pose), 'scale 1.00    fold 0.00');
  });

  test('sliding both pins keeps scale and moves the focal point', () {
    const shift = Offset(30, -10);
    final pose = solveHinge(
      restA: restA,
      restB: restB,
      liveA: restA + shift,
      liveB: restB + shift,
    );
    expect(pose.scale, closeTo(1, 0.001));
    expect(pose.rotation, closeTo(0, 0.001));
    expect(pose.anchor, const Offset(230, 190));

    final center = mapSheetPoint(
      matrix: sheetMatrix(pose: pose, sheet: sheet),
      local: const Offset(100, 200),
    );
    expect(center.dx, closeTo(230, 0.001));
    expect(center.dy, closeTo(190, 0.001));
  });

  test('a wider grip scales around the same midpoint', () {
    final pose = solveHinge(
      restA: restA,
      restB: restB,
      liveA: const Offset(50, 200),
      liveB: const Offset(350, 200),
    );
    expect(pose.scale, closeTo(1.5, 0.001));
    expect(pose.fold, 0);

    final center = mapSheetPoint(
      matrix: sheetMatrix(pose: pose, sheet: sheet),
      local: const Offset(100, 200),
    );
    expect(center.dx, closeTo(200, 0.001));
    expect(center.dy, closeTo(200, 0.001));
  });

  test('a quarter turn folds the sheet fully and keeps the midpoint', () {
    final pose = solveHinge(
      restA: restA,
      restB: restB,
      liveA: const Offset(200, 100),
      liveB: const Offset(200, 300),
    );
    expect(pose.rotation, closeTo(math.pi / 2, 0.001));
    expect(pose.scale, closeTo(1, 0.001));
    expect(pose.fold, closeTo(1, 0.001));

    final center = mapSheetPoint(
      matrix: sheetMatrix(pose: pose, sheet: sheet),
      local: const Offset(100, 200),
    );
    expect(center.dx, closeTo(200, 0.001));
    expect(center.dy, closeTo(200, 0.001));
  });

  test('scale stays inside the rail', () {
    final pose = solveHinge(
      restA: restA,
      restB: restB,
      liveA: const Offset(-4000, 200),
      liveB: const Offset(4000, 200),
    );
    expect(pose.scale, hingeScaleCeil);
    expect(pose.fold, 0);
    expect(hingeReadout(pose), isNot(contains('NaN')));
  });

  test('a collapsed rest grip does not produce NaN', () {
    final pose = solveHinge(
      restA: restA,
      restB: restA,
      liveA: const Offset(10, 10),
      liveB: const Offset(40, 80),
    );
    expect(pose.scale, 1);
    expect(pose.rotation.isNaN, isFalse);
    expect(pose.fold.isNaN, isFalse);
  });

  test('pins cannot leave the stage', () {
    const stage = Size(200, 100);
    expect(clampPin(const Offset(-40, 400), stage), const Offset(22, 78));
    expect(clampPin(const Offset(40, 40), stage), const Offset(40, 40));
  });
}
