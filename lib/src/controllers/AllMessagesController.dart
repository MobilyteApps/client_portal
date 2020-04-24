import 'package:client_portal_app/src/views/AllMessagesView.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class AllMessagesController extends ResponsiveController {
  AllMessagesController()
      : super(panelLayoutTitle: 'Messages', panelCenterTitle: true);
  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return AllMessagesView(
      layoutModel: layoutModel,
    );
  }
}
