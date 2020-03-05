import 'dart:convert';

import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/CalendarView.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';

class CalendarController extends ResponsiveController {
  CalendarController() : super(panelLayoutTitle: 'Calendar');

  Widget buildContent(LayoutModel layoutModel) {
    return createView(layoutModel);
  }

  Widget buildContentPanel(LayoutModel layoutModel) {
    return Text('coming soon to mobile');
  }

  Future<List<EventEntryModel>> getSchedule() async {
    Api api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.schedule();
    var body = json.decode(response.body);
    List<EventEntryModel> events = [];
    body.forEach((event) {
      events.add(EventEntryModel.fromJson(event));
    });
    return events;
  }

  Widget createView(LayoutModel layoutModel) {
    return FutureBuilder(
      future: getSchedule(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CalendarView(
            events: snapshot.data,
            layoutModel: layoutModel,
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
