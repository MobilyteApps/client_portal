import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  // check to see if user is logged in or not

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Login Screen',
            ),      
          ],
        ),
    );
  }
}