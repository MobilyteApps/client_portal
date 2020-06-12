import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PanelLayout extends StatefulWidget {
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
  _PanelLayoutState createState() => _PanelLayoutState();
}

class _PanelLayoutState extends State<PanelLayout> {
  RightDrawerModel rightDrawerModel;

  @override
  void initState() {
    rightDrawerModel = RightDrawerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold(
      appBar: this.widget.appBar,
      body: Container(
        child: widget.content,
      ),
    );

    return ScopedModel<RightDrawerModel>(
      child: child,
      model: rightDrawerModel,
    );
  }
}
