import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:flutter/material.dart';

import '../login_form.dart';

class LoginFormContainer extends StatelessWidget {
  final UserModel userModel;

  LoginFormContainer(this.userModel);

  Widget _logo(context) {
    if (MediaQuery.of(context).size.width > 768) {
      return SizedBox();
    }
    return Container(
      width: 330,
      margin: EdgeInsets.only(bottom: 15),
      child: Image.asset(
        'images/logo.png',
        alignment: Alignment.centerLeft,
        width: 150,
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _welcomeText(context) {
    var fontSize = 24.0;
    var text = 'Welcome';
    var fontWeight = FontWeight.w500;
    var color = Color.fromRGBO(61, 61, 61, 1);
    var margin = 0.0;

    if (MediaQuery.of(context).size.width <= 768) {
      fontSize = 14.0;
      color = Color.fromRGBO(117, 117, 117, 1);
      text = "Sign in to continue";
      margin = 10.0;
    }

    return Container(
      margin: EdgeInsets.only(bottom: margin),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _logo(context),
          SizedBox(
            width: 330,
            child: _welcomeText(context),
          ),
          SizedBox(
            width: 360,
            child: LoginForm(this.userModel),
          ),
        ],
      ),
    );
  }
}
