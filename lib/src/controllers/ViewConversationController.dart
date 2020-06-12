import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/views/ViewConversationView.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class ViewConversationController extends ResponsiveController {
  ViewConversationController({IconData icon, @required this.conversationId})
      : super(
          panelCenterTitle: false,
          panelLayoutTitle: 'Message',
          appBarIcon: icon,
        );

  final String conversationId;

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return ViewConversationView(
      conversationId: conversationId,
    );
  }
}
