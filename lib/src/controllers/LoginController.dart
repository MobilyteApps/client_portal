import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

import '../views/desktop/login.dart';

class LoginController extends StatelessWidget {
  final UserModel identity = UserModel();

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? DesktopLoginScreen(userModel: identity)
        : Text('mobile login screen');
  }
}
