import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({Key key, @required this.person}) : super(key: key);

  final PersonModel person;

  @override
  Widget build(BuildContext context) {
    List<Widget> nameAndTitle = [
      Text(person.name),
      Text(person.title != null ? person.title : '')
    ];

    return Container(
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: Text(person.avatar.text.toUpperCase()),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: nameAndTitle,
          ),
        ],
      ),
    );
  }
}
