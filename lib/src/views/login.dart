import 'package:client_portal_app/src/models/UserModel.dart';
import "package:flutter/material.dart";

import '../login_form.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // check to see if user is logged in or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/logo.png'),
                    Text('Sign in to continue'),
                  ],
                ),
              ),
            ),
            LoginForm(widget.userModel),
          ],
        ),
      ),
    );
  }
}
