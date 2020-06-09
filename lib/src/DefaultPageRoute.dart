import 'package:flutter/material.dart';

class DefaultPageRouteBuilder extends PageRouteBuilder {
  DefaultPageRouteBuilder(
      {RouteSettings settings, Widget Function(BuildContext context) builder})
      : super(
          settings: settings,
          pageBuilder: (context, anim1, anim2) {
            return builder(context);
          },
          transitionDuration: Duration(seconds: 1),
        );
}
