import 'dart:convert';

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

  List<Widget> entries(jsonBody) {
    List<Widget> entries = [];
    jsonBody.forEach((entry) {
      entries.add(
        EventEntry(
          backgroundColor: Color(int.parse(entry['backgroundColor'])),
        ),
      );
    });
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
                print(body);
                return Column(
                  children: entries(body),
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
