import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';
import 'package:client_portal_app/src/widgets/PanelLayout.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class ResponsiveController extends StatelessWidget {
  const ResponsiveController({Key key, this.panelLayoutTitle})
      : super(key: key);
  final String panelLayoutTitle;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, layoutModel) {
        if (MediaQuery.of(context).size.width >= 1024) {
          return Layout(
            model: layoutModel,
            content: buildContent(layoutModel),
          );
        }
        return PanelLayout(
          title: panelLayoutTitle,
          model: layoutModel,
          content: buildContentPanel(layoutModel),
        );
      },
    );
  }

  Widget buildContent(LayoutModel layoutModel);

  Widget buildContentPanel(LayoutModel layoutModel) {
    return buildContent(layoutModel);
  }
}
