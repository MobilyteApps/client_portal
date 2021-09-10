import 'package:client_portal_app/src/widgets/background_with_logo.dart';
import "package:flutter/material.dart";

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.onLoginPress}) : super(key: key);

  final VoidCallback onLoginPress;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Color.fromRGBO(100, 100, 100, .5),
            child: BackgroundWithLogo(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*.10),
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        color: Color.fromRGBO(117, 117, 117, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      bottom: 30,
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    color: Color.fromRGBO(0, 94, 184, 1),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: widget.onLoginPress,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 60, bottom: 60),
            constraints: BoxConstraints(
              maxWidth: 250,
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: Color.fromRGBO(117, 117, 117, 1),
                ),
                children: [
                  TextSpan(
                    text: "By continuing, you agree to Mosby Building Art's ",
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 89, 146, 1),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
