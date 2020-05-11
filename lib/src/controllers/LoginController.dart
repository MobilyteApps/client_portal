import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

import '../views/desktop/login.dart';
import '../views/welcome.dart';
import '../views/login.dart';

class LoginController extends StatefulWidget {
  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final UserModel identity = UserModel();

  Widget content;

  @override
  void initState() {
    content = kIsWeb
        ? DesktopLoginScreen(userModel: identity)
        : WelcomeScreen(
            onLoginPress: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
