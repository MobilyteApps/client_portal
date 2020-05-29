import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class AppController extends StatelessWidget {
  final Widget controller;

  AppController({@required this.controller});

  Future<LayoutModel> openBoxes() async {
    print('[AppController.dart] opening identity and project boxes');
    final Api api = Api(baseUrl: Config.apiBaseUrl);

    await Hive.openBox('identity');
    await Hive.openBox('project');

    UserModel identity = Hive.box('identity').get(0);

    if (identity == null) {
      print('[AppController.dart] identity not found');
      return LayoutModel();
    }

    // verify user is logged in
    try {
      var response = await api.me();
      // if response.body.project,
      var _body = json.decode(response.body);
      if (_body['project'] != null) {
        Hive.box('project').put(
            identity.id, ProjectModel.fromJson(json.encode(_body['project'])));
      }
    } catch (e) {
      print('[AppController.dart] identity error');
      return LayoutModel();
    }

    // re-log in

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: openBoxes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserModel model = snapshot.data.identity;
          if (model == null) {
            return ScopedModel<LayoutModel>(
              child: LoginController(),
              model: snapshot.data,
            );
          }
          return ScopedModel<LayoutModel>(
            child: controller,
            model: snapshot.data,
          );
        }

        if (snapshot.hasError) {
          return Container(
            child: Text(snapshot.error.toString()),
          );
        }

        return Container();
      },
    );
  }
}
