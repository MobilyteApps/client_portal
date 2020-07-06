import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/PaymentsView.dart';
import 'package:flutter/material.dart';

class PaymentsController extends BaseController {
  Widget buildContent(LayoutModel layoutModel, _) {
    return PaymentsView();
  }
}
