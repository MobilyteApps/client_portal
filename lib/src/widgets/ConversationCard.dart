import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/MessageModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:flutter/material.dart';

class ConversationCard extends StatelessWidget {
  const ConversationCard(
      {Key key, @required this.conversation, @required this.me})
      : super(key: key);

  final ConversationModel conversation;

  final String me;

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

    MessageModel lastMessage = conversation.lastMessage;

    PersonModel cardIdentity = PersonModel();

    if (lastMessage != null &&
        lastMessage.author != null &&
        lastMessage.recipient != null) {
      cardIdentity = lastMessage.author.id == me
          ? lastMessage.recipient
          : lastMessage.author;
    }

    print(lastMessage);

    return Container(
      padding: containerPadding,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black.withOpacity(.12)))),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: Text(cardIdentity.avatar.text),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          conversation.lastMessage.recipient != null
                              ? cardIdentity.name
                              : '',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: conversation.lastMessage.read != true
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          conversation.subject,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: conversation.lastMessage.read != true
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
    );
  }
}
