import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/ProjectLogView.dart';
import 'package:flutter/material.dart';

class HomeController extends BaseController {
  Widget buildContent(LayoutModel layoutModel, _) {
    return ProjectLogView();
  }
}
