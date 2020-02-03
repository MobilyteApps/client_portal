import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:flutter/material.dart';

import '../login_form.dart';

class LoginFormContainer extends StatelessWidget {
  final UserModel userModel;

  LoginFormContainer(this.userModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 330,
            child: Text(
              'Welcome',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(61, 61, 61, 1)),
            ),
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
