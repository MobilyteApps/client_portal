import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/controllers/CalendarController.dart';
import 'package:client_portal_app/src/controllers/HomeController.dart';
import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/controllers/PaymentController.dart';
import 'package:client_portal_app/src/controllers/ScheduleController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/views/CalendarView.dart';
import 'package:client_portal_app/src/views/ProjectLogView.dart';
import 'package:client_portal_app/src/views/ScheduleView.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'controllers/AppController.dart';

class AppMain extends StatefulWidget {
  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  Widget content;

  Widget controller;

  @override
  void initState() {
    super.initState();
    content = ProjectLogView();
  }

  Widget createController(Widget child) {
    return AppController(
      controller: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    var home = createController(HomeController());

    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
            case '/schedule':
              return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => createController(ScheduleController()));
            case '/login':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => LoginController(),
              );
              break;
            case '/calendar':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(CalendarController()),
              );
            case '/payments':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(PaymentController()),
              );

              break;
          }
        });
  }
}
