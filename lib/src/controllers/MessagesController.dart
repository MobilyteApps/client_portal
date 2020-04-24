import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/views/RecentMessagesView.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class MessagesController extends BaseController {
  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return RecentMessagesView(
      layoutModel: layoutModel,
    );
  }
}
