import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/controllers/AllMessagesController.dart';
import 'package:client_portal_app/src/controllers/BillingAndPaymentsController.dart';
import 'package:client_portal_app/src/controllers/CalendarController.dart';
import 'package:client_portal_app/src/controllers/HomeController.dart';
import 'package:client_portal_app/src/controllers/InvoicesController.dart';
import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/controllers/MessagesController.dart';
import 'package:client_portal_app/src/controllers/NewMessageController.dart';
import 'package:client_portal_app/src/controllers/ScheduleController.dart';
import 'package:client_portal_app/src/controllers/TeamController.dart';
import 'package:client_portal_app/src/controllers/ViewConversationController.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/ProjectLogView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controllers/AppController.dart';
import 'controllers/PaymentsController.dart';

class AppMain extends StatefulWidget {
  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  Widget content;

  Widget controller;

  final Api api = Api(baseUrl: Config.apiBaseUrl);

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
        title: 'Mosby Client Portal',
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
                builder: (context) => createController(LoginController()),
              );
              break;
            case '/calendar':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(CalendarController()),
              );
            case '/billing':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) =>
                    createController(BillingAndPaymentsController()),
              );
              break;
            case '/billing/payments':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(PaymentsController()),
              );
              break;
            case '/billing/invoices':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(InvoicesController()),
              );
              break;
            case '/team':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(TeamController()),
              );
              break;
            case '/new-message':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(NewMessageController()),
              );
              break;
            case '/all-messages':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(AllMessagesController()),
              );
              break;
            case '/messages':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) => createController(MessagesController()),
              );
              break;
            case '/view-conversation':
              return MaterialPageRoute(
                settings: settings,
                builder: (context) =>
                    createController(ViewConversationController()),
              );
              break;
            default:
              return MaterialPageRoute(
                  settings: settings,
                  builder: (_) =>
                      createController(Center(child: Text('404 Not found'))));
          }
        });
  }
}
