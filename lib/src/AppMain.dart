import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/RoutePath.dart';
import 'package:client_portal_app/src/controllers/AllMessagesController.dart';
import 'package:client_portal_app/src/controllers/BillingAndPaymentsController.dart';
import 'package:client_portal_app/src/controllers/CalendarController.dart';
import 'package:client_portal_app/src/controllers/HomeController.dart';
import 'package:client_portal_app/src/controllers/InvoicesController.dart';
import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/controllers/MessagesController.dart';
import 'package:client_portal_app/src/controllers/NewMessageController.dart';
import 'package:client_portal_app/src/controllers/ResetPasswordController.dart';
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

  Widget createController(Widget child, [bool requiresAuth = true]) {
    return AppController(
      controller: child,
      requiresAuth: requiresAuth,
    );
  }

  PageRoute dynamicRouteMatch(RouteSettings settings) {
    List<RoutePath> paths = [
      RoutePath(
          pattern: r'^/view-conversation/([\w-]+)$',
          builder: (context, match) => createController(
              ViewConversationController(conversationId: match), true))
    ];

    for (RoutePath path in paths) {
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name)) {
        final firstMatch = regExpPattern.firstMatch(settings.name);
        final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;

        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, match),
          settings: settings,
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var home = createController(HomeController(), true);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mosby Client Portal',
        theme: ThemeData(
          primarySwatch: Brand.primary,
        ),
        home: home,
        onGenerateRoute: (RouteSettings settings) {
          PageRoute dynamicPageRoute;

          // dynamic page route matching
          if ((dynamicPageRoute = dynamicRouteMatch(settings)) != null) {
            return dynamicPageRoute;
          }

          // exact match routes
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
                builder: (context) =>
                    createController(LoginController(), false),
              );
              break;
            case '/login/reset-password':
              return MaterialPageRoute(
                settings: settings,
                builder: (_) =>
                    createController(ResetPasswordController(), false),
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
