import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/PaymentView.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';
import 'package:client_portal_app/src/widgets/PanelLayout.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PaymentController extends ResponsiveController {
  const PaymentController() : super(panelLayoutTitle: 'Billing & Payments');

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, layoutModel) {
        if (MediaQuery.of(context).size.width >= 1024) {
          return Layout(
            model: layoutModel,
            content: buildContent(layoutModel),
          );
        }
        return PanelLayout(
          title: 'Billing & Payments',
          model: layoutModel,
          content: buildContent(layoutModel),
        );
      },
    );
  }

  Widget buildContent(LayoutModel layoutModel) {
    return PaymentView(layoutModel: layoutModel);
  }
}
