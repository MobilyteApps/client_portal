import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/NewMessageView.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:client_portal_app/src/widgets/PersonAvatar.dart';
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

  Widget _messageButton(context, PersonModel person) {
    if (person.messagingOptIn == false) {
      return SizedBox();
    }

    return TextButton(
      style: TextButton.styleFrom(backgroundColor:Brand.primary ,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),),
      child: Text(
        'Message'.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),

      onPressed: () {
        if (MediaQuery.of(context).size.width >= 1024) {
          Navigator.pushNamed(context, '/new-message', arguments: person);
        } else {
          Navigator.push(
            context,
            SlideUpRoute(
              settings: RouteSettings(arguments: person),
              page: PanelScaffold(
                title: 'New Message',
                body: NewMessageView(),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _avatar(BuildContext context, PersonModel person) {
    return PersonAvatar(
      person: person,
    );
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
                      _avatar(context, snapshot.data[index]),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(snapshot?.data[index]?.name),
                            Text(snapshot?.data[index]?.title),
                          ],
                        ),
                      ),
                      _messageButton(context, snapshot?.data[index]),
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
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
      future: _getTeam(),
    );
  }
}
