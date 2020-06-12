import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/widgets/PersonAvatar.dart';
import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({Key key, @required this.person}) : super(key: key);

  final PersonModel person;

  @override
  Widget build(BuildContext context) {
    List<Widget> nameAndTitle = [
      Text(person != null && person.name != null ? person.name : ''),
      Text(person != null && person.title != null ? person.title : '')
    ];

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: nameAndTitle,
          ),
        ],
      ),
    );
  }
}
