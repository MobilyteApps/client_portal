import 'package:client_portal_app/src/controllers/ProjectLogController.dart';
import "package:flutter/material.dart";

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Color.fromRGBO(100, 100, 100, .5),
              child: Row(              
                children: [
                  Expanded(
                    child: Padding(child: Center(child: Text('logo here')), padding: EdgeInsets.all(100),),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 100, bottom: 50),child: Text(
                'Welcome',
              ),             
            ),
            Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                color: Color.fromRGBO(0, 94, 184, 1),
                child: Text('Login', style: TextStyle(color: Colors.white),), 
                onPressed: () {
                  // @todo check if logged in,  if not, navigate to the login screen, otherwise the home screen
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => ProjectLogController()));
                },
              ),
            ),  
            Padding(padding: EdgeInsets.only(top: 100), child: Text("By continuing, you agree to Mosby Building Art's Terms of Service"),)   
          ],
        ),
    );
  }
}