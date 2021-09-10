import 'dart:convert';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/ContentView.dart';
import 'package:client_portal_app/src/views/DocumentView.dart';
import 'package:client_portal_app/src/views/TeamView.dart';
import 'package:client_portal_app/src/views/WhattoExpectView.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Menu.dart';

class MenuSecondary extends StatelessWidget {
  MenuSecondary({this.layoutModel, this.textStyle});

  final LayoutModel layoutModel;

  final TextStyle textStyle;

  final Api _api = Api(baseUrl: Config.apiBaseUrl);

  Future<String> getPageContent(pageId) async {
    try {
      var response = await _api.getPageContent(pageId);
      var _json = json.decode(response.body);
      return _json['content'];
    } catch (error) {
      return '<p>error fetching page</p>';
    }
  }

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
                  body: BillingAndPaymentsView(layoutModel: layoutModel),
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
      ListTile(
        title: Text(
          'What to Expect',
          style: textStyle,
        ),
        leading: FaIcon(FontAwesomeIcons.key),
        onTap: (){
          if (width >= 1024) {
          } else {
            Navigator.push(
              context,
              SlideUpRoute(
                settings: RouteSettings(),
                page: PanelScaffold(title: 'What to Expect', body: WhattoExpectView()),
              ),
            );
          }
        },
      ),
      ListTile(
        title: Text(
          'Documents',
          style: textStyle,
        ),
        leading: FaIcon(FontAwesomeIcons.file),
        onTap: (){
          if (width >= 1024) {
          } else {
            Navigator.push(
              context,
              SlideUpRoute(
                settings: RouteSettings(),
                page: PanelScaffold(title: 'Documents', body: DocumentView()),
              ),
            );
          }
        },
      ),
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
                  body: FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ContentView(
                          html: snapshot.data,
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                    },
                    future: getPageContent('help'),
                  ),
                ),
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
