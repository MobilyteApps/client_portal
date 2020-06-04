import 'dart:async';
import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/MessageModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/LoadingIndicator.dart';
import 'package:client_portal_app/src/widgets/PersonCard.dart';
import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';

class ViewConversationView extends StatefulWidget {
  const ViewConversationView(
      {Key key, @required this.layoutModel, this.conversationId})
      : super(key: key);

  final LayoutModel layoutModel;

  final String conversationId;

  @override
  _ViewConversationViewState createState() => _ViewConversationViewState();
}

class _ViewConversationViewState extends State<ViewConversationView> {
  var api = Api(baseUrl: Config.apiBaseUrl);

  ConversationModel conversationModel;

  EventSource eventSource;

  Future<ConversationModel> getConversation(String id) async {
    var response = await api.getConversation(id);
    return ConversationModel.fromJson(response.body);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshConversation() async {
    if (widget.conversationId != null) {
      var _conversation = await getConversation(widget.conversationId);
      setState(() {
        conversationModel = _conversation;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      refreshConversation();
    });
  }

  List<Widget> _cards(List<MessageModel> messages) {
    return messages.map((e) {
      String authorName =
          e.author.id == widget.layoutModel.identity.id.toString()
              ? 'You'
              : e.author.name;

      TextStyle textStyle = TextStyle(
        color: authorName == 'You' ? Colors.white.withOpacity(.87) : null,
        fontSize: 14,
      );

      return Card(
        elevation: 0,
        margin: EdgeInsets.only(bottom: 10),
        color:
            authorName == 'You' ? Brand.primary : Colors.black.withOpacity(.12),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(authorName,
                      style: textStyle.copyWith(
                          fontSize: 13, fontWeight: FontWeight.w500)),
                  SizedBox(width: 10),
                  Text(
                    e.humanReadableTimestamp,
                    style: textStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                e.message,
                style: textStyle,
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _replyTextController = TextEditingController();

    if (conversationModel == null) {
      return Container();
    }

    PersonModel personModel =
        conversationModel.identity(widget.layoutModel.identity.id.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 35, left: 20, right: 20),
          child: Text(
            conversationModel.subject,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 25),
          child: PersonCard(
            person: personModel,
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            shrinkWrap: true,
            children: _cards(conversationModel.messages),
          ),
        ),
        Container(
          color: Color(0xFFEEEEEE),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _replyTextController,
              validator: (value) {
                if (value.length == 0) {
                  return 'Please enter a message';
                }
                return null;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelText: 'Reply',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        final Api api = Api(baseUrl: Config.apiBaseUrl);
                        await api.replyToConversation(conversationModel.id,
                            _replyTextController.value.text);

                        refreshConversation();
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
