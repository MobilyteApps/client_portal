import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/controllers/PaymentController.dart';
import 'package:client_portal_app/src/controllers/MenuPrimaryController.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/AppController.dart';

class AppMain extends StatefulWidget {
  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var home = AppController(
      controller: MenuPrimaryController(),
    );

    return MaterialApp(
        title: 'Client Portal',
        theme: ThemeData(
          primarySwatch: Brand.primary,
        ),
        home: home,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => home,
              );
              break;
            case '/login':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => LoginController(),
              );
              break;

            case '/payments':
              return CupertinoPageRoute(
                settings: settings,
                builder: (context) => AppController(
                  controller: PaymentController(),
                ),
              );
              break;
          }
        });
  }
}
