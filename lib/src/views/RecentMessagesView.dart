import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/AllMessagesView.dart';
import 'package:client_portal_app/src/views/NewMessageView.dart';
import 'package:client_portal_app/src/widgets/ConversationCard.dart';
import 'package:client_portal_app/src/widgets/MyCustomScrollBehaviour.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:flutter/material.dart';

class RecentMessagesView extends StatefulWidget {
  const RecentMessagesView({Key key, @required this.layoutModel})
      : super(key: key);

  final LayoutModel layoutModel;

  @override
  _RecentMessagesViewState createState() => _RecentMessagesViewState();
}

class _RecentMessagesViewState extends State<RecentMessagesView> {
  Future<List<ConversationModel>> conversations() async {
    print('loading conversations');
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
        me: widget.layoutModel != null
            ? widget.layoutModel.identity.id.toString()
            : '',
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
          onPressed: () async {
            if (MediaQuery.of(context).size.width >= 1024) {
              await Navigator.pushNamed(context, '/new-message');
            } else {
              await Navigator.push(
                context,
                SlideUpRoute(
                  settings: RouteSettings(),
                  page: PanelScaffold(
                    title: 'New Message',
                    body: NewMessageView(),
                  ),
                ),
              );
            }
            setState(() {});
          },
        )
      ],
    );
  }

  Widget button(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
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
                  settings: RouteSettings(),
                  page: PanelScaffold(
                    title: 'Messages',
                    body: AllMessagesView(
                      layoutModel: widget.layoutModel,
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          if (MediaQuery.of(context).size.width >= 1024) {
                            Navigator.pushNamed(context, '/new-message');
                          } else {
                            Navigator.push(
                              context,
                              SlideUpRoute(
                                settings: RouteSettings(),
                                page: PanelScaffold(
                                  title: 'New Message',
                                  body: NewMessageView(),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ));
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
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        // List<Widget> _columns =
        //     List<Widget>.from(conversationCards(snapshot.data));
        //
        // _columns.add(button(context));

        EdgeInsets padding = EdgeInsets.only(top: 30, left: 15, right: 15);

        if (MediaQuery.of(context).size.width >= 1024) {
          padding = padding.copyWith(left: 60, right: 60, bottom: 10);
        }

        return Container(
          padding: padding,
          child: Column(
            children: [
              heading(context),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    ConversationModel conversations= snapshot.data[index];
                return ConversationCard(me: widget.layoutModel!=null? widget.layoutModel.identity.id.toString():"",conversation: conversations);

              }),
            ],
          ),
        );
      },
    );
  }
}
