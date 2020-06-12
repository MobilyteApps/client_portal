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
  }) : super(
          key: key,
          body: body,
          appBar: AppBar(
            title: Text(title),
            actions: actions,
            leading: leading == null ? PanelCloseButton() : leading,
          ),
        );
}
