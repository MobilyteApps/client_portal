import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/controllers/NewMessageController.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:flutter/material.dart';

class TeamView extends StatelessWidget {
  const TeamView({Key key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var padding = EdgeInsets.only(top: 20);

          return Padding(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var padding = EdgeInsets.all(15);
                if (MediaQuery.of(context).size.width >= 1024) {
                  padding = padding.copyWith(left: 0, right: 0);
                }
                return Container(
                  padding: padding,
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(.12)))),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        child: Text('sc'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(snapshot.data[index].name),
                            Text(snapshot.data[index].title),
                          ],
                        ),
                      ),
                      FlatButton(
                        color: Brand.primary,
                        child: Text(
                          'Message'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          if (MediaQuery.of(context).size.width >= 1024) {
                            Navigator.pushNamed(context, '/new-message',
                                arguments: snapshot.data[index]);
                          } else {
                            Navigator.push(
                              context,
                              SlideUpRoute(
                                settings: RouteSettings(
                                    arguments: snapshot.data[index]),
                                page: AppController(
                                  controller: NewMessageController(),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                );
              },
              itemCount: snapshot.data.length,
            ),
            padding: padding,
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: _getTeam(),
    );
  }
}
