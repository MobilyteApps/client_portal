import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/transitions/SlideLeftRoute.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

import '../views/desktop/login.dart';
import '../views/welcome.dart';

class LoginController extends StatefulWidget {
  final bool showLogin;

  LoginController({this.showLogin = false});

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final UserModel identity = UserModel();

  Widget content;

  @override
  void initState() {
    content = kIsWeb || widget.showLogin
        ? DesktopLoginScreen(userModel: identity)
        : WelcomeScreen(
            onLoginPress: () {
              Navigator.of(context).pushReplacement(
                SlideLeftRoute(
                  settings: RouteSettings(
                    arguments: {},
                  ),
                  page: AppController(
                    controller: LoginController(showLogin: true),
                    requiresAuth: false,
                  ),
                ),
              );
            },
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
