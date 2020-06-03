import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/controllers/ViewConversationController.dart';
import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/transitions/SlideLeftRoute.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
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

    var _avatar;

    if (cardIdentity.avatar.url != null && cardIdentity.avatar.url.length > 0) {
      _avatar = CircleAvatar(
        backgroundImage: NetworkImage(cardIdentity.avatar.url),
      );
    } else {
      _avatar = CircleAvatar(
        child: Text(
          cardIdentity.avatar.text == null ? '' : cardIdentity.avatar.text,
        ),
      );
    }

    return InkWell(
      onTap: () async {
        if (MediaQuery.of(context).size.width >= 1024) {
          await Navigator.pushNamed(context, '/view-conversation',
              arguments: conversation.id);
        } else if (routeAnimationDirection == 'up') {
          Navigator.push(
            context,
            SlideUpRoute(
              settings: RouteSettings(arguments: conversation.id),
              page: AppController(
                controller: ViewConversationController(),
              ),
            ),
          );
        } else if (routeAnimationDirection == 'rtl') {
          Navigator.push(
            context,
            SlideLeftRoute(
              settings: RouteSettings(arguments: conversation),
              page: AppController(
                controller: ViewConversationController(
                  icon: Icons.arrow_back,
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
            _avatar,
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
