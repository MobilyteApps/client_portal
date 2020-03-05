import 'package:flutter/material.dart';

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({this.page})
      : super(
          transitionsBuilder:
              (context, animation, secondAnimation, Widget child) {
            return SlideTransition(
              child: child,
              position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                  .animate(animation),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondAnimation) {
            return page;
          },
        );
}
