import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/BillingAndPaymentsView.dart';

import 'package:flutter/material.dart';

class BillingAndPaymentsController extends ResponsiveController {
  const BillingAndPaymentsController()
      : super(panelLayoutTitle: 'Billing and Payments');

  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return BillingAndPaymentsView(layoutModel: layoutModel);
  }
}
