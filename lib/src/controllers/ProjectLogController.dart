import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';
import 'package:client_portal_app/src/widgets/Note.dart';
import 'package:client_portal_app/src/widgets/ProjectLogHeader.dart';
import 'package:http/http.dart' as http;

import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

class ProjectLogController extends StatelessWidget {
  Future<http.Response> getProjectLog() {
    final Api api = Api(baseUrl: Config.apiBaseUrl);
    return api.projectLog();
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, model) {
        List<Widget> items = [];

        return FutureBuilder(
          future: getProjectLog(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //print(snapshot.data.body.toString());

              List<dynamic> result = json.decode(snapshot.data.body.toString());

              result.forEach((entry) {
                print(entry);
                items.add(ProjectLogHeader(title: entry['date']));
                entry['notes'].forEach((note) {
                  items.add(
                    Note(
                      author: note['author'],
                      photoUrl: note['photoUrl'],
                      note: note['note'],
                    ),
                  );
                });
              });

              return Layout(
                content: Container(
                  constraints: BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Column(
                    children: items,
                  ),
                ),
                model: model,
              );
            }

            return Container();
          },
        );
      },
    );
  }
}
