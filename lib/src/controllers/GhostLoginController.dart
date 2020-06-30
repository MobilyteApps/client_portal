import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/SplitLayout.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class GhostLoginController extends StatefulWidget {
  GhostLoginController({Key key, @required this.code}) : super(key: key);

  final String code;

  @override
  _GhostLoginControllerState createState() => _GhostLoginControllerState();
}

class _GhostLoginControllerState extends State<GhostLoginController> {
  final _formKey = GlobalKey<FormState>();

  final UserModel identity = UserModel();

  String pin;
  InputDecoration _textFieldDecoration(String labelText,
      [bool enabled = true]) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      enabled: enabled,
      border: OutlineInputBorder(),
    );
  }

  Widget _button() {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, _, layoutModel) {
        return SizedBox(
          width: double.infinity,
          child: RaisedButton(
            color: Brand.primary,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                try {
                  var api = Api(baseUrl: Config.apiBaseUrl);
                  var response = await api.pinLogin(widget.code, pin);

                  switch (response.statusCode) {
                    case 200:
                      var body = json.decode(response.body.toString());

                      await identity.login(body);

                      var project = await ProjectModel.load(body['id']);
                      if (project != null) {
                        layoutModel.setProject(project);
                      }
                      Navigator.of(context).pushReplacementNamed('/');
                      break;
                    case 401:
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Invalid Code or PIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                      break;
                    case 422:
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Invalid Code or PIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                      break;
                  }
                } catch (error) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  ));
                }
              }
            },
            padding: EdgeInsets.all(15),
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplitLayout(
      child: Center(
        child: Form(
          key: _formKey,
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.code,
                  decoration: _textFieldDecoration('Code', false),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Code is required';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: '',
                  decoration: _textFieldDecoration('PIN'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'PIN is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      pin = value;
                    });
                  },
                ),
                SizedBox(height: 15),
                _button(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
