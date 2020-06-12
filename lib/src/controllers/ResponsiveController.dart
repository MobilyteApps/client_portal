import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';
import 'package:client_portal_app/src/widgets/PanelLayout.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class ResponsiveController extends StatelessWidget {
  const ResponsiveController({
    Key key,
    this.panelLayoutTitle,
    this.panelCenterTitle = false,
    this.appBarIcon,
  }) : super(key: key);
  final String panelLayoutTitle;
  final bool panelCenterTitle;
  final IconData appBarIcon;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, layoutModel) {
        if (MediaQuery.of(context).size.width >= 1024) {
          return Layout(
            model: layoutModel,
            content: buildContent(layoutModel, context),
          );
        }
        return PanelLayout(
          model: layoutModel,
          appBar: buildAppBar(context),
          content: buildContentPanel(layoutModel, context),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      actions: [],
      elevation: 0,
      backgroundColor: Color(Brand.primaryDark),
      centerTitle: panelCenterTitle,
      title: Text(panelLayoutTitle),
      leading: IconButton(
        icon: Icon(appBarIcon == null ? Icons.close : appBarIcon),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget buildContent(LayoutModel layoutModel, BuildContext context);

  Widget buildContentPanel(LayoutModel layoutModel, BuildContext context) {
    return buildContent(layoutModel, context);
  }
}
