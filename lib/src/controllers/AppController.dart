import 'package:client_portal_app/src/models/UserModel.dart';
import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

import 'LoginController.dart';
import 'ProjectLogController.dart';

class AppController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, widget, model) {
        return model.isAuthenticated()
            ? ProjectLogController()
            : LoginController();
      },
    );
  }
}
