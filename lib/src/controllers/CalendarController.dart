import 'dart:convert';

import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/reducers/EventEntryReducer.dart';
import 'package:client_portal_app/src/views/CalendarView.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';

class CalendarController extends ResponsiveController {
  CalendarController() : super(panelLayoutTitle: 'Calendar');

  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return createView(layoutModel);
  }

  Widget buildContentPanel(LayoutModel layoutModel, BuildContext context) {
    return createView(layoutModel);
  }

  Future<List<Map<String, dynamic>>> getSchedule() async {
    Api api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.schedule();
    var body = json.decode(response.body);
    return List<Map<String, dynamic>>.from(body);
  }

  Widget createView(LayoutModel layoutModel) {
    return FutureBuilder(
      future: getSchedule(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var reducer = EventEntryReducer(
              payload: List<Map<String, dynamic>>.from(snapshot.data));

          reducer.reduce();

          return CalendarView(
            events: reducer.asSplayTreeMap(),
            layoutModel: layoutModel,
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
