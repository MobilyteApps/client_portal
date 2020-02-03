import 'package:flutter/material.dart';

import 'Menu.dart';

class MenuSecondary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Menu(
      items: [
        ListTile(title: Text('Billing and Payments'), leading: Icon(Icons.payment),),
        ListTile(title: Text('Your Mosby Team'), leading: Icon(Icons.group),),
        ListTile(title: Text('Project Documentation'), leading: Icon(Icons.inbox),),
        ListTile(title: Text('Settings'), leading: Icon(Icons.settings),),
        ListTile(title: Text('Help & Feedback'), leading: Icon(Icons.live_help),),
      ],
    );
  }
}
