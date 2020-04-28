import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:flutter/material.dart';

class PanelLayout extends StatelessWidget {
  PanelLayout({
    Key key,
    this.model,
    @required this.content,
    @required this.appBar,
  });

  final LayoutModel model;

  final Widget content;

  final Widget appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBar,
      body: Container(
        child: content,
      ),
    );
  }
}
