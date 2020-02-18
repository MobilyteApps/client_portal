import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/Note.dart';
import 'package:client_portal_app/src/widgets/ProjectLogHeader.dart';
import 'package:http/http.dart' as http;

import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

class ProjectLogView extends StatelessWidget {
  Future<http.Response> getProjectLog() {
    final Api api = Api(baseUrl: Config.apiBaseUrl);
    return api.projectLog();
  }

  Widget listViewContent(items) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: items,
    );
  }

  double rightPadding(BuildContext context) {
    double padding = MediaQuery.of(context).size.width - ((600 + 300));
    return padding > 0 ? padding : 0;
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, model) {
        List<Widget> items = [];

        return FutureBuilder(
          future: getProjectLog(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              http.Response r = snapshot.data;

              if (r.statusCode == 200 || r.statusCode == 201) {
                List<dynamic> result = json.decode(r.body);

                result.asMap().forEach((index, entry) {
                  items.add(ProjectLogHeader(
                    title: entry['date'],
                    icon: entry['weather']['iconUrl'],
                  ));
                  entry['notes'].forEach((note) {
                    items.add(
                      Note(
                        author: note['author'],
                        photoUrl: note['photoUrl'],
                        note: note['note'],
                      ),
                    );
                  });

                  if (entry['photos'].length > 0) {
                    items.add(
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Divider(
                          color: Colors.black54,
                        ),
                      ),
                    );
                    items.add(
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 10),
                        child: Text(
                          'Photos',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    );

                    ListView photoListView = ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: entry['photos'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Image.network(entry['photos'][index]['url']),
                        );
                      },
                    );

                    items.add(
                      Container(
                        height: 130,
                        padding: EdgeInsets.only(bottom: 30, left: 15),
                        child: photoListView,
                      ),
                    );
                  }
                });
              }

              return Container(
                padding: EdgeInsets.only(
                  right: rightPadding(context),
                  top: 50,
                ),
                child: listViewContent(items),
              );
            }

            return Container();
          },
        );
      },
    );
  }
}
