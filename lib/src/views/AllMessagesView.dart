import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/ConversationCard.dart';
import 'package:client_portal_app/src/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';

class AllMessagesView extends StatefulWidget {
  AllMessagesView({Key key, @required this.layoutModel}) : super(key: key);

  final LayoutModel layoutModel;

  @override
  _AllMessagesViewState createState() => _AllMessagesViewState();
}

class _AllMessagesViewState extends State<AllMessagesView> {
  int cursor;

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<ConversationModel>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        List<Widget> _cards = snapshot.data.map((e) {
          return ConversationCard(
            conversation: e,
            me: widget.layoutModel.identity.id.toString(),
            routeAnimationDirection: 'rtl',
          );
        }).toList();

        return Container(
          padding: EdgeInsets.only(top: 25),
          child: ListView(
            shrinkWrap: true,
            children: _cards,
          ),
        );
      },
      future: conversations(),
    );
  }
}