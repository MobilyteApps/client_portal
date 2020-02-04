import 'dart:convert';
import 'package:http/http.dart' as http;
import 'controllers/ProjectLogController.dart';
import 'models/UserModel.dart';

import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final UserModel userModel;

  LoginForm(this.userModel);

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  bool passwordVisible;

  bool rememberMe;

  String email;

  String password;

  @override
  void initState() {
    passwordVisible = false;
    rememberMe = false;
  }

  Future<http.Response> doLogin(email, password, bool rememberMe) {
    Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'rememberMe': rememberMe ? '1' : '0'
    };
    return http.post('http://localhost:8080/index.php?r=site/login',
        body: body);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                onSaved: (val) {
                  setState(() {
                    password = val;
                  });
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: passwordVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Checkbox(
                    value: rememberMe,
                    onChanged: (newValue) {
                      setState(() {
                        rememberMe = newValue;
                      });
                    },
                  ),
                  Text('Remember me'),
                  Spacer(),
                  FlatButton(
                    child: Text(
                      'Forgot password',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 89, 146, 1),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.only(
                top: 50,
              ),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                color: Color.fromRGBO(0, 89, 146, 1),
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Logging in.  Please wait...'),
                    ));
                    try {
                      http.Response response =
                          await doLogin(email, password, rememberMe);

                      switch (response.statusCode) {
                        case 200:
                          var body = json.decode(response.body.toString());

                          widget.userModel.login(body);
                          // navigate to home screen
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      ProjectLogController()));

                          break;
                        case 401:
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Invalid email or password',
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                      }
                    } catch (e) {
                      print(e);
                      // probably a CORS issue if the error is an XMLHttpRequest error
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Network error has occured - ' + e,
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                    }
                  }
                },
              ),
            ),
          ],
        ));
  }
}
