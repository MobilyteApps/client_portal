import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class AboutController extends ResponsiveController {
  AboutController()
      : super(
          panelLayoutTitle: 'About',
          panelCenterTitle: true,
        );

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return Container(
        child: Center(
      child: Text('about'),
    ));
  }
}
