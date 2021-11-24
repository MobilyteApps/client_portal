import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//Created customer scroll behaviour in order to listen for events
class MyCustomScrollBehaviour extends MaterialScrollBehavior{

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    PointerDeviceKind.touch,
  };
}