import 'package:desk/desk_app.dart';
import 'package:desk/hinge_view.dart';
import 'package:flutter/material.dart';

void main() {
  final params = Uri.base.queryParameters;
  final turned = params['pose'] == 'turned';
  runApp(
    DeskApp(
      openHinge: params['open'] == 'hinge',
      demo: turned ? HingeDemo.turned : HingeDemo.rest,
    ),
  );
}
