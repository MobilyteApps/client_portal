import 'package:client_portal_app/src/models/UserModel.dart';
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
  // check to see if user is logged in or not

  Widget buildForMobile() {
    return Container(
      child: LoginFormContainer(widget.userModel),
    );
  }

  Widget buildForWeb() {
    return Row(
      children: <Widget>[
        Expanded(          
          flex: 5,
          child: BackgroundWithLogo(),
        ),
        Expanded(
          flex: 5,
          child: LoginFormContainer(widget.userModel),
        ),
      ],
    );
  }

  Widget scaffold(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return Container(
              child: buildForWeb(),
            );
          } else {
            return Center(
              child: buildForMobile(),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }
}
