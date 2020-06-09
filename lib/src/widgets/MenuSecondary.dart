import 'package:flutter/material.dart';

import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/controllers/TeamController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Menu.dart';

class MenuSecondary extends StatelessWidget {
  final TextStyle textStyle = TextStyle(
    fontSize: 14,
  );

  List<Widget> items(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return [
      /*ListTile(
        title: Text(
          'Billing and Payments',
          style: textStyle,
        ),
        leading: Icon(Icons.payment),
        onTap: () {
          if (width >= 1024) {
            Navigator.pushNamed(context, '/billing');
          } else {
            Navigator.push(
              context,
              SlideUpRoute(
                page: AppController(
                  controller: BillingAndPaymentsController(),
                ),
              ),
            );
          }
        },
      ),*/
      ListTile(
        title: Text(
          'Your Mosby Team',
          style: textStyle,
        ),
        leading: Icon(Icons.group),
        onTap: () {
          if (width >= 1024) {
            Navigator.pushNamed(context, '/team');
          } else {
            Navigator.push(
              context,
              SlideUpRoute(
                page: AppController(
                  requiresAuth: true,
                  controller: TeamController(),
                ),
              ),
            );
          }
        },
      ),
      /*ListTile(
        title: Text(
          'Project Documentation',
          style: textStyle,
        ),
        leading: Icon(Icons.inbox),
      ),*/
      /*ListTile(
        title: Text(
          'Settings',
          style: textStyle,
        ),
        leading: Icon(Icons.settings),
      ),*/
      ListTile(
        title: Text(
          'Help & Feedback',
          style: textStyle,
        ),
        leading: Icon(Icons.live_help),
        onTap: () {
          Navigator.of(context).pushNamed('/help-and-feedback');
        },
      ),
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12),
          ),
        ),
        child: ListTile(
          title: Text('Logout', style: textStyle),
          leading: Icon(Icons.exit_to_app),
          onTap: () {
            LayoutModel layoutModel = ScopedModel.of<LayoutModel>(context);
            layoutModel.identity.logout();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      items: items(context),
    );
  }
}
