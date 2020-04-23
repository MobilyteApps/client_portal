import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:flutter/material.dart';

class PanelLayout extends StatelessWidget {
  PanelLayout(
      {Key key,
      this.model,
      this.content,
      @required this.title,
      this.centerTitle = false});

  final LayoutModel model;

  final Widget content;

  final String title;

  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    print(model.project);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(Brand.primaryDark),
        centerTitle: centerTitle,
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: content,
      ),
    );
  }
}
