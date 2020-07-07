import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/InvoicesView.dart';
import 'package:flutter/material.dart';

class InvoicesController extends BaseController {
  @override
  Widget buildContent(LayoutModel layoutModel, _) {
    return InvoicesView();
  }
}
