import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/PhotoPageView.dart';
import 'package:client_portal_app/src/widgets/MyCustomScrollBehaviour.dart';
import 'package:client_portal_app/src/widgets/Note.dart';
import 'package:client_portal_app/src/widgets/ProjectLogHeader.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

class ProjectLogView extends StatelessWidget {
  Future<http.Response> getProjectLog() {
    final Api api = Api(baseUrl: Config.apiBaseUrl);
    return api.projectLog();
  }

  Widget listViewContent(items,context) {
    EdgeInsets padding = EdgeInsets.only(
      top: 0,
      left: 10,
      right: 0,
    );
    return ScrollConfiguration(
        behavior: MyCustomScrollBehaviour(),
        child: ListView(
          padding: EdgeInsets.only(left: kIsWeb && MediaQuery.of(context).size.width >= 1024?60:0,right: kIsWeb&& MediaQuery.of(context).size.width >= 1024?20:0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: items,
        ));
  }

  double rightPadding(BuildContext context) {
    double padding = MediaQuery.of(context).size.width - ((600 + 800));
    return padding > 0 ? padding : 0;
  }

  ListView photoListView(context, entry) {
    ListView photoListView = ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: entry['photos'].length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(1),
          child: _image(
              context, entry['photos'][index]['url'], entry['photos'], index),
        );
      },
    );

    return photoListView;
  }

  GridView photoGridView(context, entry) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: entry['photos'].length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(3),
          child: _image(
              context, entry['photos'][index]['url'], entry['photos'], index),
        );
      },
    );
  }

  Widget _image(context, String url, List photos, int index) {
    return InkWell(
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return PhotoPageView(
                photos: photos,
                initialPage: index,
              );
            });
      },
    );
  }

  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;

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
                    temperatureHigh:
                        entry['weather']['temperatureHigh'].toString(),
                    temperatureLow:
                        entry['weather']['temperatureLow'].toString(),
                    precipitation: entry['weather']['precipitation'],
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
                    items.add(
                      Container(
                        height: mediaQueryWidth >= 1024 ? null : 130,
                        padding: EdgeInsets.only(
                            bottom: 30,
                            left: mediaQueryWidth >= 1024 ? 12 : 14),
                        child: mediaQueryWidth >= 1024
                            ? photoGridView(context, entry)
                            : photoListView(context, entry),
                      ),
                    );
                  }
                });
              }
              EdgeInsets padding = EdgeInsets.only(
                top: 20,
                left: 0,
                right: 60,
              );

              if (mediaQueryWidth < 1024) {
                padding = EdgeInsets.all(0);
              }
              return Container(
                child: listViewContent(items,context),
                padding: padding,
              );
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        );
      },
    );
  }
}
