import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:flutter/material.dart';

class PaymentsController extends BaseController {
  Widget buildContent(LayoutModel layoutModel) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackButtonHeading(),
          Expanded(
            child: ListView(
              children: <Widget>[
                Text('Last Payment'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
