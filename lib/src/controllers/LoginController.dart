import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

import '../views/desktop/login.dart';

class LoginController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, widget, model) {
        return kIsWeb ? DesktopLoginScreen(userModel: model) : Text('mobile login screen');
      },
    );
  }
}
