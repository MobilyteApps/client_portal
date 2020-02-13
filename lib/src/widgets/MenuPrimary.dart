import "package:flutter/material.dart";

import 'Menu.dart';

class MenuPrimary extends StatelessWidget {
  final TextStyle textStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  List<ListTile> items(BuildContext context) {
    return [
      ListTile(
        leading: Icon(
          Icons.library_books,
          color: Colors.white,
        ),
        title: Text(
          'Project Log',
          style: textStyle,
        ),
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
      ),
      ListTile(
        leading: Icon(
          Icons.event_note,
          color: Colors.white,
        ),
        title: Text(
          'Schedule',
          style: textStyle,
        ),
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/schedule');
        },
      ),
      ListTile(
        leading: Icon(
          Icons.inbox,
          color: Colors.white,
        ),
        title: Text(
          'Project',
          style: textStyle,
        ),
      ),
      ListTile(
        leading: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        title: Text(
          'Notifications',
          style: textStyle,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      backgroundColor: Color.fromRGBO(0, 169, 209, 1),
      items: items(context),
    );
  }
}
