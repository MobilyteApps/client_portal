import 'package:client_portal_app/src/controllers/BaseController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:flutter/material.dart';

class InvoicesController extends BaseController {
  @override
  Widget buildContent(LayoutModel layoutModel, _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 40, top: 30, bottom: 15),
          child: BackButtonHeading(),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(left: 60, right: 60),
            children: <Widget>[
              Text('Current Invoice'),
            ],
          ),
        )
      ],
    );
  }
}
