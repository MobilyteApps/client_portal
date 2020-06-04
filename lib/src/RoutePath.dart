import 'package:flutter/material.dart';

class RoutePath {
  final String pattern;
  final Widget Function(BuildContext, String) builder;

  RoutePath({this.pattern, this.builder});
}
