import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/transitions/SlideLeftRoute.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/views/ViewConversationView.dart';
import 'package:client_portal_app/src/widgets/PanelBackButton.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:client_portal_app/src/widgets/PersonAvatar.dart';
import 'package:flutter/material.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard({
    Key key,
    @required this.conversation,
    @required this.me,
    this.routeAnimationDirection = 'up',
  }) : super(key: key);

  final ConversationModel conversation;

  final String me;

  final String routeAnimationDirection;

  String truncateMessage(String message, int length) {
    if (message == null) {
      return '';
    }
    if (message.length > length) {
      return message.substring(0, length) + '...';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets containerPadding = EdgeInsets.only(top: 15, bottom: 15);
    if (MediaQuery.of(context).size.width < 1024) {
      containerPadding =
          EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20);
    }

    PersonModel cardIdentity = conversation.identity(me);

    return InkWell(
      onTap: () async {
        if (MediaQuery.of(context).size.width >= 1024) {
          await Navigator.pushNamed(
              context, '/view-conversation/${conversation.id}',
              arguments: {'userId': me, 'conversationId': conversation.id});
        } else if (routeAnimationDirection == 'up') {
          Navigator.push(
            context,
            SlideUpRoute(
                settings: RouteSettings(arguments: {
                  'userId': me,
                  'conversationId': conversation.id
                }),
                page: PanelScaffold(
                    title: 'Message',
                    body: ViewConversationView(
                      conversationId: conversation.id,
                    ))),
          );
        } else if (routeAnimationDirection == 'rtl') {
          Navigator.push(
            context,
            SlideLeftRoute(
              settings: RouteSettings(
                  arguments: {'userId': me, 'conversationId': conversation.id}),
              page: PanelScaffold(
                leading: PanelBackButton(),
                title: 'Message',
                body: ViewConversationView(
                  conversationId: conversation.id,
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: containerPadding,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(.12)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PersonAvatar(
              person: cardIdentity,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            cardIdentity != null ? cardIdentity.name : '',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: conversation.read != true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            conversation.subject,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: conversation.read != true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        conversation.humanReadableTimestamp,
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      truncateMessage(conversation.lastMessage.message, 48),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
