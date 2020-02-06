import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class AppController extends StatelessWidget {
  final Widget controller;

  AppController({@required this.controller});

  Future<LayoutModel> openBoxes() async {
    await Hive.openBox('identity');
    await Hive.openBox('project');

    UserModel identity = Hive.box('identity').get(0);

    ProjectModel project = Hive.box('project').get(identity.id);

    if (project == null) {
      final Api api = Api(baseUrl: Config.apiBaseUrl);
      final http.Response response = await api.project();
      final ProjectModel model =
          ProjectModel.fromJson(response.body.toString());

      Hive.box('project').put(identity.id, model);
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
            return LoginController();
          }
          return ScopedModel<LayoutModel>(
            child: controller,
            model: snapshot.data,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
