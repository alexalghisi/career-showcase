import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class HingePose {
  const HingePose({
    required this.scale,
    required this.rotation,
    required this.anchor,
    required this.fold,
  });

  final double scale;
  final double rotation;
  final Offset anchor;
  final double fold;
}

const hingeScaleFloor = 0.45;
const hingeScaleCeil = 2.8;

HingePose solveHinge({
  required Offset restA,
  required Offset restB,
  required Offset liveA,
  required Offset liveB,
}) {
  final rest = restB - restA;
  final live = liveB - liveA;
  final restLen = rest.distance;
  final liveLen = live.distance;
  final raw = restLen == 0 ? 1.0 : liveLen / restLen;
  final scale = raw.clamp(hingeScaleFloor, hingeScaleCeil).toDouble();
  final rotation = math.atan2(live.dy, live.dx) - math.atan2(rest.dy, rest.dx);
  final anchor = Offset((liveA.dx + liveB.dx) / 2, (liveA.dy + liveB.dy) / 2);
  final fold = (rotation.abs() / (math.pi / 2)).clamp(0.0, 1.0).toDouble();
  return HingePose(
    scale: scale,
    rotation: rotation,
    anchor: anchor,
    fold: fold,
  );
}

Matrix4 sheetMatrix({required HingePose pose, required Size sheet}) {
  final matrix = Matrix4.identity();
  matrix.translateByDouble(pose.anchor.dx, pose.anchor.dy, 0, 1);
  matrix.rotateZ(pose.rotation);
  matrix.scaleByDouble(pose.scale, pose.scale, 1, 1);
  matrix.translateByDouble(-sheet.width / 2, -sheet.height / 2, 0, 1);
  return matrix;
}

Offset mapSheetPoint({required Matrix4 matrix, required Offset local}) {
  final storage = matrix.storage;
  final x = local.dx;
  final y = local.dy;
  return Offset(
    storage[0] * x + storage[4] * y + storage[12],
    storage[1] * x + storage[5] * y + storage[13],
  );
}

String hingeReadout(HingePose pose) {
  final scale = pose.scale.toStringAsFixed(2);
  final fold = pose.fold.toStringAsFixed(2);
  return 'scale $scale    fold $fold';
}

Offset clampPin(Offset pin, Size stage) {
  const margin = 22.0;
  final maxX = math.max(margin, stage.width - margin);
  final maxY = math.max(margin, stage.height - margin);
  return Offset(
    pin.dx.clamp(margin, maxX).toDouble(),
    pin.dy.clamp(margin, maxY).toDouble(),
  );
}

Size sheetSizeFor(Size stage) {
  final width = math.min(440.0, math.max(220.0, stage.width * 0.56));
  final height = math.min(540.0, math.max(280.0, stage.height * 0.72));
  return Size(width, height);
}
