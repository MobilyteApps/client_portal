import 'dart:convert';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:client_portal_app/src/widgets/EventEntryDetailPanel.dart';
import 'package:intl/intl.dart';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/EventEntry.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class ScheduleView extends StatelessWidget {
  Future<http.Response> upNext() {
    Api api = Api(baseUrl: Config.apiBaseUrl);
    return api.upNext();
  }

  List<Widget> entries(jsonBody, context, LayoutModel model) {
    DateFormat dateFormat = DateFormat('EEEEE, MMMM d');
    List<String> trackDates = [];

    List<Widget> entries = [];
    jsonBody.forEach((entry) {
      DateTime startDate = DateTime.parse(entry['startDateTime']);
      String mdy = dateFormat.format(startDate);

      if (trackDates.contains(mdy) == false) {
        trackDates.add(mdy);
        entries.add(Container(
          child: Text(mdy),
          margin: EdgeInsets.only(top: 25),
        ));
      }

      entries.add(
        EventEntry(
          title: entry['title'],
          backgroundColor: entry['backgroundColor'],
          textColor: entry['textColor'],
          trailing: entry['trailing'],
          startDateTime: entry['startDateTime'],
          endDateTime: entry['endDateTime'],
          location: entry['location'],
          description: entry['description'],
          onTap: (EventEntry eventEntry) {
            Scaffold.of(context).openEndDrawer();
            ScopedModel.of<RightDrawerModel>(context).setContent(
              EventEntryDetailPanel(
                eventEntry: eventEntry,
              ),
            );
          },
        ),
      );
    });

    if (entries.length > 0) {
      entries.add(
        Container(
          alignment: Alignment.centerRight,
          child: FlatButton(
            hoverColor: Colors.transparent,
            padding: EdgeInsets.all(0),
            onPressed: () {
              print('open the panel');
              Navigator.of(context).pushNamed('/calendar');
            },
            child: Text(
              'VIEW FULL SCHEDULE',
              style: TextStyle(
                color: Brand.primary,
              ),
            ),
          ),
        ),
      );
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, layoutModel) {
        return FutureBuilder(
          future: upNext(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              http.Response response = snapshot.data;
              if (response.statusCode == 200 || response.statusCode == 201) {
                var body = json.decode(response.body.toString());
                return Container(
                  constraints: BoxConstraints(maxWidth: 480),
                  padding: EdgeInsets.only(top: 60, left: 60, right: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Upcoming Dates',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: entries(body, context, layoutModel),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('api error: ' + response.reasonPhrase);
              }
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
