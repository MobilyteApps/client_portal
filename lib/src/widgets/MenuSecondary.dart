import 'package:flutter/material.dart';

import 'Menu.dart';

class MenuSecondary extends StatelessWidget {
  final TextStyle textStyle = TextStyle(
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Menu(
      items: [
        ListTile(
          title: Text(
            'Billing and Payments',
            style: textStyle,
          ),
          leading: Icon(Icons.payment),
        ),
        ListTile(
          title: Text(
            'Your Mosby Team',
            style: textStyle,
          ),
          leading: Icon(Icons.group),
        ),
        ListTile(
          title: Text(
            'Project Documentation',
            style: textStyle,
          ),
          leading: Icon(Icons.inbox),
        ),
        ListTile(
          title: Text(
            'Settings',
            style: textStyle,
          ),
          leading: Icon(Icons.settings),
        ),
        ListTile(
          title: Text(
            'Help & Feedback',
            style: textStyle,
          ),
          leading: Icon(Icons.live_help),
        ),
      ],
    );
  }
}
