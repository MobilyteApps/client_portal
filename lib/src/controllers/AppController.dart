import 'dart:async';
import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/LoadingIndicator.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class AppController extends StatefulWidget {
  final Widget controller;
  final bool requiresAuth;

  AppController({@required this.controller, @required this.requiresAuth});

  @override
  _AppControllerState createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  Future<LayoutModel> openBoxes() async {
    print('[AppController.dart] opening identity and project boxes');
    final Api api = Api(baseUrl: Config.apiBaseUrl);

    await Hive.openBox('identity');
    await Hive.openBox('project');

    UserModel identity = Hive.box('identity').get(0);

    // forces login screen if no identity is found in local storage
    if (identity == null) {
      print('[AppController.dart] identity not found');
      return LayoutModel();
    }

    // determine if we need to verify the identity at the server
    var _shouldVerifyLogin = await shouldVerifyLogin();

    // verify user is logged in
    if (_shouldVerifyLogin) {
      try {
        var response = await api.me();
        // if response.body.project,
        var _body = json.decode(response.body);
        if (_body['project'] != null) {
          Hive.box('project').put(identity.id,
              ProjectModel.fromJson(json.encode(_body['project'])));
        }
        await Hive.openBox('bin');
        Hive.box('bin').put('lastLoginVerify', DateTime.now());
      } catch (e) {
        print('[AppController.dart] identity error');
        return LayoutModel();
      }
    } else {
      print('identity is fresh');
    }

    // check for project
    ProjectModel project =
        Hive.box('project').get(identity != null ? identity.id : null);

    if (project == null) {
      try {
        final http.Response response = await api.project();
        final ProjectModel model =
            ProjectModel.fromJson(response.body.toString());
        Hive.box('project').put(identity.id, model);
      } catch (e) {
        print(e);
      }
    }

    if (project == null) {
      project = ProjectModel();
    }

    return LayoutModel(project: project, identity: identity);
  }

  Future<bool> shouldVerifyLogin() async {
    await Hive.openBox('bin');
    DateTime lastLoginVerify = Hive.box('bin').get('lastLoginVerify');

    if (lastLoginVerify == null) {
      return true;
    }

    DateTime now = DateTime.now();

    var diff = now.difference(lastLoginVerify);

    print('identity is ' + diff.inSeconds.toString() + ' seconds old');

    // 15 minutes
    return diff.inSeconds > 900;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: openBoxes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserModel model = snapshot?.data?.identity;

        
          if (model == null && widget.requiresAuth) {
            return ScopedModel<LayoutModel>(
              child: LoginController(),
              model: snapshot.data??LayoutModel(),
            );
          }

          return ScopedModel<LayoutModel>(
            child: widget.controller,
            model: snapshot.data,
          );
        }

        if (snapshot.hasError) {
          return Container(
            child: Text(snapshot.error.toString()),
          );
        }

        return Container(
          color: Colors.white,
          child: Center(
            child: LoadingIndicator(),
          ),
        );
      },
    );
  }
}
