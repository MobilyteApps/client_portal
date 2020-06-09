import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/validators/EmptyValidator.dart';
import 'package:client_portal_app/src/widgets/TextHeading.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key key}) : super(key: key);

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  List<FocusNode> _verificationNodes;
  List<TextEditingController> _verificationTextControllers;
  TextEditingController _emailTextController;
  TextEditingController _passwordTextController;
  TextEditingController _confirmPasswordTextController;
  int _step = 1;
  Api _api;
  String _challengeCode;

  @override
  void initState() {
    super.initState();
    _api = Api(baseUrl: Config.apiBaseUrl);
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordTextController = TextEditingController();

    _verificationNodes = [FocusNode(), FocusNode(), FocusNode()];
    _verificationTextControllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController()
    ];
  }

  @override
  void dispose() {
    for (var node in _verificationNodes) {
      node.dispose();
    }
    _emailTextController.dispose();
    super.dispose();
  }

  void _handleError(error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          error.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _handleVerificationControlSubmit() async {
    // fire off api request that includes the 9 digit code and email address
    var one = _verificationTextControllers[0].value.text;
    var two = _verificationTextControllers[1].value.text;
    var three = _verificationTextControllers[2].value.text;

    var code = '${one}${two}${three}';
    var email = _emailTextController.value.text;

    try {
      var response = await _api.verifyResetCode(email, code);
      var body = json.decode(response.body);
      setState(() {
        _step = 3;
        _challengeCode = body['challenge'];
      });
    } catch (error) {
      _handleError(error);
    }
  }

  Widget _verificationCodeControl() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 60,
          child: TextFormField(
            controller: _verificationTextControllers[0],
            onChanged: (value) {
              if (value.length == 3) {
                _verificationNodes[1].requestFocus();
              }
            },
            onFieldSubmitted: (_) {
              _handleVerificationControlSubmit();
            },
            focusNode: _verificationNodes[0],
            textAlign: TextAlign.center,
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(top: 5, bottom: 5)),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 60,
          child: TextFormField(
            controller: _verificationTextControllers[1],
            focusNode: _verificationNodes[1],
            onChanged: (value) {
              if (value.length == 3) {
                _verificationNodes[2].requestFocus();
              }
            },
            onFieldSubmitted: (_) {
              _handleVerificationControlSubmit();
            },
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(top: 5, bottom: 5)),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 60,
          child: TextFormField(
            controller: _verificationTextControllers[2],
            focusNode: _verificationNodes[2],
            textAlign: TextAlign.center,
            maxLength: 3,
            maxLengthEnforced: true,
            onFieldSubmitted: (_) {
              _handleVerificationControlSubmit();
            },
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 5, bottom: 5),
            ),
          ),
        ),
        SizedBox(width: 10),
        RaisedButton(
          color: Brand.primary,
          onPressed: _handleVerificationControlSubmit,
          padding: EdgeInsets.only(top: 14, bottom: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.arrow_forward, color: Colors.white, size: 16),
            ],
          ),
        ),
      ],
    );
  }

  void _handleEmailAddressControl() async {
    if (_formKey.currentState.validate()) {
      try {
        await _api.requestPasswordResetCode(_emailTextController.value.text);
        setState(() {
          _step = 2;
        });
      } catch (error) {
        _handleError(error);
      }
    }
  }

  Widget _emailAddressControl() {
    return TextFormField(
      autofocus: true,
      onFieldSubmitted: (_) {
        _handleEmailAddressControl();
      },
      keyboardType: TextInputType.emailAddress,
      validator: EmptyValidator().validate,
      controller: _emailTextController,
      decoration: InputDecoration(
          labelText: 'Email address',
          suffixIcon: InkWell(
            child: Icon(Icons.send),
            onTap: _handleEmailAddressControl,
          )),
    );
  }

  void _handlePasswordInputControlSubmit() async {
    if (_formKey.currentState.validate()) {
      try {
        // take the new password and confirm password and if they match... send them to the api
        var password = _passwordTextController.value.text;

        // if the api responds okay,  then Navigate to Login
        await _api.saveNewPassword(_challengeCode, password);

        Navigator.pop(context, 'passwordChangeSuccess');
      } catch (error) {
        _handleError(error);
      }
    }
  }

  Widget _passwordInputControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          autofocus: true,
          controller: _passwordTextController,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty || value.length < 6) {
              return 'Password must be at least 6 characters long.';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'New password',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _confirmPasswordTextController,
          obscureText: true,
          validator: (value) {
            if (value != _passwordTextController.value.text) {
              return 'Confirm password must match Password';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            _handlePasswordInputControlSubmit();
          },
          decoration: InputDecoration(
            labelText: 'Confirm password',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 15),
          ),
        ),
        SizedBox(height: 20),
        Container(
          child: RaisedButton(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            color: Brand.primary,
            child: Text(
              'Save Password',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: _handlePasswordInputControlSubmit,
          ),
        )
      ],
    );
  }

  Widget _inputControl() {
    switch (_step) {
      case 1:
        return _emailAddressControl();
      case 2:
        return _verificationCodeControl();
      case 3:
        return _passwordInputControl();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, layoutModel) {
        return Center(
          child: SizedBox(
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextHeading(
                    text: 'Password Reset',
                  ),
                  SizedBox(height: 5),
                  Text(
                      'Enter your email address and we will send you a verification code.'),
                  SizedBox(height: 15),
                  _inputControl(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
