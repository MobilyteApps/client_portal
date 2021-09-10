import 'dart:convert';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'models/UserModel.dart';
import 'Api.dart';
import 'utils/Config.dart';

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

  Api api = Api(baseUrl: Config.apiBaseUrl);

  bool rememberMe;

  String email;

  String password;

  FocusNode _passwordNode;

  @override
  void initState() {
    passwordVisible = false;
    rememberMe = false;
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    super.dispose();
  }

  void _doLogin(LayoutModel layoutModel) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Logging in.  Please wait...'),
      ));
      try {
        http.Response response = await api.login(email, password, rememberMe);
        print("-------$response");

        switch (response.statusCode) {
          case 200:
            var body = json.decode(response.body.toString());

            await widget.userModel.login(body);

            var project = await ProjectModel.load(body['id']);
            if (project != null) {
              layoutModel.setProject(project);
            }
            layoutModel.saveDeviceToken();
            Navigator.of(context).pushReplacementNamed('/');
            break;
          case 401:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Invalid email or password',
                style: TextStyle(color: Colors.white),
              ),
            ));
            break;
          case 422:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Invalid email or password',
                style: TextStyle(color: Colors.white),
              ),
            ));
            break;
        }
      } catch (e) {
        // probably a CORS issue if the error is an XMLHttpRequest error
        print("--------------${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Network error has occured - ' + e.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, _, layoutModel) {
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
                    focusNode: _passwordNode,
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
                    onFieldSubmitted: (value) {
                      _doLogin(layoutModel);
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      /*Checkbox(
                        value: rememberMe,
                        onChanged: (newValue) {
                          setState(() {
                            rememberMe = newValue;
                          });
                        },
                      ),
                      Text('Remember me'),
                      Spacer(),
                      */
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text(
                            'Forgot password',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 89, 146, 1),
                            ),
                          ),
                          onPressed: () async {
                            var response = await Navigator.of(context)
                                .pushNamed('/login/reset-password');

                            if (response == 'passwordChangeSuccess') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'You may now log in with your new password.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.only(
                    top: 50,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      primary: Color.fromRGBO(0, 89, 146, 1),
                      backgroundColor: Color.fromRGBO(0, 89, 146, 1),
                    ),
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      _doLogin(layoutModel);
                    },
                  ),
                ),
              ],
            ));
      },
    );
  }
}
