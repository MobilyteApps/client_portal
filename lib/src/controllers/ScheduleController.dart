import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/ScheduleView.dart';
import 'package:flutter/material.dart';

class ScheduleController extends BaseController {
  Widget buildContent(LayoutModel layoutModel) {
    return ScheduleView();
  }
}
