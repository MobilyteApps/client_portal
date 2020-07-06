import 'package:client_portal_app/src/widgets/PanelCloseButton.dart';
import 'package:flutter/material.dart';

class PanelScaffold extends Scaffold {
  final Widget body;

  final Widget leading;

  PanelScaffold({
    Key key,
    List<Widget> actions,
    String title,
    this.body,
    this.leading,
    bool centerTitle = true,
  }) : super(
          key: key,
          body: body,
          appBar: AppBar(
            centerTitle: centerTitle,
            elevation: 0,
            title: Text(title),
            actions: actions,
            leading: leading == null ? PanelCloseButton() : leading,
          ),
        );
}
