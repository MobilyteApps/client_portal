import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/DefaultPageRoute.dart';
import 'package:client_portal_app/src/RoutePath.dart';
import 'package:client_portal_app/src/controllers/AllMessagesController.dart';
import 'package:client_portal_app/src/controllers/BillingAndPaymentsController.dart';
import 'package:client_portal_app/src/controllers/CalendarController.dart';
import 'package:client_portal_app/src/controllers/ContentController.dart';
import 'package:client_portal_app/src/controllers/GhostLoginController.dart';
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
import 'package:client_portal_app/src/views/NotFoundView.dart';
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
            ViewConversationController(conversationId: match), true),
      ),
      RoutePath(
        pattern: r'^/login/ghost/([A-Za-z0-9-_]+)$',
        builder: (context, match) =>
            createController(GhostLoginController(code: match), false),
      )
    ];

    if (settings == null) {
      return null;
    }

    for (RoutePath path in paths) {
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name)) {
        final firstMatch = regExpPattern.firstMatch(settings.name);
        final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;

        return DefaultPageRouteBuilder(
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
          primaryColor: Color(Brand.primaryDark),
        ),
        onGenerateRoute: (RouteSettings settings) {
          PageRoute dynamicPageRoute;

          // dynamic page route matching
          if ((dynamicPageRoute = dynamicRouteMatch(settings)) != null) {
            return dynamicPageRoute;
          }

          // exact match routes
          switch (settings != null ? settings.name : '') {
            case '/':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => home,
              );
              break;
            case '/schedule':
              return DefaultPageRouteBuilder(
                  settings: settings,
                  builder: (context) => createController(ScheduleController()));
            case '/login':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) =>
                    createController(LoginController(), false),
              );
              break;
            case '/login/reset-password':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (_) =>
                    createController(ResetPasswordController(), false),
              );
              break;
            case '/calendar':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(CalendarController()),
              );
            case '/billing':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) =>
                    createController(BillingAndPaymentsController()),
              );
              break;
            case '/billing/payments':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(PaymentsController()),
              );
              break;
            case '/billing/invoices':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(InvoicesController()),
              );
              break;
            case '/team':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(TeamController()),
              );
              break;
            case '/new-message':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(NewMessageController()),
              );
              break;
            case '/all-messages':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(AllMessagesController()),
              );
              break;
            case '/messages':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(MessagesController()),
              );
              break;
            case '/view-conversation':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) =>
                    createController(ViewConversationController()),
              );
              break;
            case '/help-and-feedback':
              return DefaultPageRouteBuilder(
                settings: settings,
                builder: (context) => createController(ContentController(
                  pageId: 'help',
                  panelLayoutTitle: 'Help & Feedback',
                )),
              );

            default:
              return DefaultPageRouteBuilder(
                  settings: settings,
                  builder: (context) =>
                      createController(NotFoundView(), false));
          }
        });
  }
}
