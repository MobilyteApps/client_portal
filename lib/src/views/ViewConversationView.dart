import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/ConversationModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/MessageModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/LoadingIndicator.dart';
import 'package:client_portal_app/src/widgets/PersonCard.dart';
import 'package:flutter/material.dart';

class ViewConversationView extends StatelessWidget {
  const ViewConversationView({Key key, @required this.layoutModel})
      : super(key: key);

  final LayoutModel layoutModel;

  Future<ConversationModel> getConversation(String id) async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.getConversation(id);
    print(response.body);
    return ConversationModel.fromJson(response.body);
  }

  List<Widget> _cards(List<MessageModel> messages) {
    return messages.map((e) {
      String authorName = e.author.id == layoutModel.identity.id.toString()
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
    var id = ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
      future: getConversation(id),
      builder: (context, AsyncSnapshot<ConversationModel> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        ConversationModel conversation = snapshot.data;

        PersonModel personModel =
            conversation.identity(layoutModel.identity.id.toString());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 35, left: 20, right: 20),
              child: Text(
                conversation.subject,
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
                children: _cards(conversation.messages),
              ),
            ),
            Container(
              color: Color(0xFFEEEEEE),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  labelText: 'Reply',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      print('pressed');
                    },
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
