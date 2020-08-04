import 'package:client_portal_app/src/views/ContentView.dart';
import 'package:client_portal_app/src/views/BillingAndPaymentsView.dart';
import 'package:client_portal_app/src/views/TeamView.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:flutter/material.dart';
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
                settings: RouteSettings(),
                page: PanelScaffold(
                  title: 'Billing & Payments',
                  body: BillingAndPaymentsView(),
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
                settings: RouteSettings(),
                page: PanelScaffold(title: 'Your Mosby Team', body: TeamView()),
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
          if (MediaQuery.of(context).size.width >= 1024) {
            Navigator.of(context).pushNamed('/help-and-feedback');
          } else {
            Navigator.push(
              context,
              SlideUpRoute(
                settings: RouteSettings(),
                page: PanelScaffold(
                    title: 'Help & Feedback',
                    body: ContentView(
                      html: '<p>todo</p>',
                    )),
              ),
            );
          }
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
