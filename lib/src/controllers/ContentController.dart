import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/ContentView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class ContentController extends ResponsiveController {
  ContentController({
    Key key,
    String panelLayoutTitle,
    bool panelCenterTitle = false,
    IconData appBarIcon,
    this.pageId,
  }) : super(
            panelLayoutTitle: panelLayoutTitle,
            panelCenterTitle: panelCenterTitle,
            appBarIcon: appBarIcon);

  final String pageId;

  final _api = Api(baseUrl: Config.apiBaseUrl);

  Future<String> getPageContent() async {
    var response = await _api.getPageContent(pageId);
    var _json = json.decode(response.body);
    return _json['content'];
  }

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          EdgeInsets titlePadding =
              EdgeInsets.only(top: 30, left: 30, right: 30);

          if (MediaQuery.of(context).size.width >= 1024) {
            titlePadding = titlePadding.copyWith(left: 60, right: 60, top: 20);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Help & Feedback',
                  style: Theme.of(context).textTheme.headline6,
                ),
                padding: titlePadding,
              ),
              ContentView(
                html: snapshot.data,
              )
            ],
          );
        }

        return Container(
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
      future: getPageContent(),
    );
  }
}
