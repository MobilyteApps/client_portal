import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/widgets/SplitLayout.dart';
import "package:flutter/material.dart";

import '../../widgets/background_with_logo.dart';
import '../../widgets/login_form_container.dart';

class DesktopLoginScreen extends StatefulWidget {
  DesktopLoginScreen({Key key, this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  _DesktopLoginScreenState createState() => _DesktopLoginScreenState();
}

class _DesktopLoginScreenState extends State<DesktopLoginScreen> {
  Widget scaffold(BuildContext context) {
    return SplitLayout(
        child: Center(child: LoginFormContainer(widget.userModel)));
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }
}
