import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/MessageModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/PersonAvatar.dart';
import 'package:flutter/material.dart';

class NewMessageView extends StatefulWidget {
  NewMessageView({Key key, this.team}) : super(key: key);

  final List<PersonModel> team;

  @override
  _NewMessageViewState createState() => _NewMessageViewState();
}

class _NewMessageViewState extends State<NewMessageView> {
  MessageModel message = MessageModel();
  PersonModel toPerson = PersonModel();
  String subject;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<ConversationModel> submitMessage(
      String subject, MessageModel messageModel, String to) async {
    var api = Api(baseUrl: Config.apiBaseUrl);

    var response = await api.newConversation(subject, messageModel, to);

    return ConversationModel.fromJson(response.body);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        PersonModel args = ModalRoute.of(context).settings == null
            ? null
            : ModalRoute.of(context).settings.arguments;
        if (args != null) {
          toPerson = args;
        }
        message = MessageModel();
      });
    });
  }

  Widget toField(value, List<PersonModel> teamMembers) {
    var margin = EdgeInsets.only(left: 20, right: 20);
    if (MediaQuery.of(context).size.width >= 1024) {
      margin = EdgeInsets.all(0);
    }
    return Container(
      margin: margin,
      child: Row(
        children: <Widget>[
          Text(
            'To:',
            textAlign: TextAlign.right,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              child: DropdownButton(
                underline: SizedBox(),
                isExpanded: true,
                hint: Align(
                  child: Text('Select team member'),
                  alignment: Alignment.centerLeft,
                ),
                value: value,
                selectedItemBuilder: (context) {
                  return teamMembers.map<Widget>((person) {
                    return Align(
                      child: Text(person.name),
                      alignment: Alignment.centerLeft,
                    );
                  }).toList();
                },
                items: teamMembers.map(
                  (person) {
                    return DropdownMenuItem<String>(
                      value: person.id,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            PersonAvatar(
                              person: person,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(person.name),
                                Text(person.title),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    var to = teamMembers
                        .firstWhere((element) => element.id == value);

                    toPerson = to;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: Colors.black.withOpacity(.12), width: 1))),
    );
  }

  Widget subjectField() {
    var margin = EdgeInsets.only(left: 20, right: 20);
    if (MediaQuery.of(context).size.width >= 1024) {
      margin = EdgeInsets.only(left: 0, right: 0, bottom: 50);
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.black.withOpacity(.12)))),
      child: Row(
        children: <Widget>[
          Text(
            'Subject:',
            textAlign: TextAlign.right,
          ),
          SizedBox(width: 20),
          Expanded(
            child: TextFormField(
              onSaved: (value) {
                setState(() {
                  subject = value;
                });
              },
              decoration: InputDecoration(border: InputBorder.none),
              validator: (value) {
                if (value.length == 0) {
                  return 'Subject is required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _spacer() {
    if (MediaQuery.of(context).size.width < 1024) {
      return Expanded(
        child: SizedBox(),
      );
    }
    return SizedBox();
  }

  void _doSubmit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      var conversation = await submitMessage(subject, message, toPerson.id);
      Navigator.of(context).pop(conversation);
    }
  }

  @override
  Widget build(BuildContext context) {
    var messageFieldPadding = EdgeInsets.all(20);

    if (MediaQuery.of(context).size.width >= 1024) {
      messageFieldPadding = null;
    }

    return Container(
      padding: EdgeInsets.only(top: 40),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                toField(toPerson != null ? toPerson.id : null, widget.team),
                subjectField(),
              ],
            ),
            _spacer(),
            TextFormField(
              validator: (value) {
                if (value.length == 0) {
                  return 'Message is required';
                }
                return null;
              },
              onSaved: (value) {
                setState(() {
                  message = message.copyWith(message: value);
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  message = message.copyWith(message: value);
                  _doSubmit();
                });
              },
              decoration: InputDecoration(
                contentPadding: messageFieldPadding,
                filled: true,
                fillColor: Color(0xFFEEEEEE),
                labelText: 'Message',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    _doSubmit();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
