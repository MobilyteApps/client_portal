import 'dart:convert';

import 'package:client_portal_app/src/models/AvatarModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/NewMessageView.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

import '../Api.dart';

class NewMessageController extends ResponsiveController {
  NewMessageController()
      : super(panelCenterTitle: true, panelLayoutTitle: 'New Message');
  Future<List<PersonModel>> _getTeam() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.team();
    List<Map<String, dynamic>> _json =
    List<Map<String, dynamic>>.from(json.decode(response.body));
    return _json.map((e) {
      return PersonModel.fromMap(e);
    }).toList();
  }

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context ) {
    return Padding(
      padding: EdgeInsets.only(left: 60, top: 30, right: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackButtonHeading(),
          SizedBox(
            height: 30,
          ),
          Text(
            'New Message',
            style: Theme.of(context).textTheme.headline6,
          ),
          NewMessageView(needDropDown: false ),
        ],
      ),
    );
  }

  Widget buildContentPanel(LayoutModel layoutModel, BuildContext context) {
    return NewMessageView(

    );
  }
}
