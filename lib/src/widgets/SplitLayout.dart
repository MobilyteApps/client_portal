import 'package:client_portal_app/src/widgets/background_with_logo.dart';
import 'package:flutter/material.dart';

class SplitLayout extends StatelessWidget {
  final Widget child;
  const SplitLayout({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: BackgroundWithLogo(),
                ),
                Expanded(
                  child: child,
                )
              ],
            );
          } else {
            return child;
          }
        },
      ),
    );
  }
}
