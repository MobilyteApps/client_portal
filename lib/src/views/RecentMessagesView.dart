import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/controllers/AllMessagesController.dart';
import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/controllers/NewMessageController.dart';
import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/ConversationCard.dart';
import 'package:flutter/material.dart';

class RecentMessagesView extends StatelessWidget {
  const RecentMessagesView({Key key, @required this.layoutModel})
      : super(key: key);

  final LayoutModel layoutModel;

  Future<List<ConversationModel>> conversations() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.recentConversations();
    List<Map<String, dynamic>> _json =
        List<Map<String, dynamic>>.from(json.decode(response.body));

    var _conversations = _json.map((e) {
      var c = ConversationModel.fromMap(e);
      return c;
    }).toList();

    return _conversations;
  }

  List<Widget> conversationCards(List<ConversationModel> conversations) {
    if (conversations == null) {
      return [];
    }
    return conversations.map((e) {
      return ConversationCard(
        me: layoutModel != null ? layoutModel.identity.id.toString() : '',
        conversation: e,
      );
    }).toList();
  }

  Widget heading(context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Recent Messages',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Brand.primary,
          ),
          onPressed: () {
            if (MediaQuery.of(context).size.width >= 1024) {
              Navigator.pushNamed(context, '/new-message');
            } else {
              Navigator.push(
                context,
                SlideUpRoute(
                  page: AppController(
                    controller: NewMessageController(),
                  ),
                ),
              );
            }
          },
        )
      ],
    );
  }

  Widget button(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(
          'View all messages'.toUpperCase(),
          style: TextStyle(color: Brand.primary),
        ),
        onPressed: () {
          if (MediaQuery.of(context).size.width >= 1024) {
            Navigator.pushNamed(context, '/all-messages');
          } else {
            Navigator.push(
              context,
              SlideUpRoute(
                page: AppController(
                  controller: AllMessagesController(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: conversations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        List<Widget> _columns =
            List<Widget>.from(conversationCards(snapshot.data));

        _columns.add(button(context));

        _columns.insert(0, heading(context));

        return Container(
          padding: EdgeInsets.only(top: 30, left: 15, right: 15),
          child: Column(
            children: _columns,
          ),
        );
      },
    );
  }
}
