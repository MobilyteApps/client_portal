import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:flutter/material.dart';

class PanelLayout extends StatelessWidget {
  PanelLayout({Key key, this.model, this.content, @required this.title});

  final LayoutModel model;

  final Widget content;

  final String title;

  @override
  Widget build(BuildContext context) {
    print(model.project);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        constraints: BoxConstraints(maxWidth: 300),
        color: Colors.red,
        child: content,
      ),
    );
  }
}
