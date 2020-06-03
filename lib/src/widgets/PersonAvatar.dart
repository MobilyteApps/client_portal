import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:flutter/material.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar({Key key, this.person}) : super(key: key);

  final PersonModel person;

  @override
  Widget build(BuildContext context) {
    var _child;
    var _background;

    if (person.avatar.url != null && person.avatar.url.length > 0) {
      _background = NetworkImage(person.avatar.url);
    } else {
      _child = Text(person.avatar.text != null ? person.avatar.text : '');
    }

    return CircleAvatar(
      child: _child,
      backgroundImage: _background,
    );
  }
}
