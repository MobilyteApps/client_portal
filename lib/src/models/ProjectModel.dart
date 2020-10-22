import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'package:hive/hive.dart';

part 'ProjectModel.g.dart';

@HiveType(typeId: 1)
class ProjectModel extends Model {
  @HiveField(0)
  String title;

  @HiveField(1)
  String coverPhoto;

  @HiveField(2)
  String id;

  ProjectModel({this.title, this.coverPhoto, this.id});

  ProjectModel.fromJson(dynamic body) {
    dynamic j = json.decode(body);
    this.title = j['title'];
    this.coverPhoto = j['coverPhoto'];
    this.id = j['id'];
  }

  static Future<ProjectModel> load(int userId) async {
    await Hive.openBox('project');

    ProjectModel project = Hive.box('project').get(userId);

    if (project != null && project.id == null) {
      return project;
    }

    final Api api = Api(baseUrl: Config.apiBaseUrl);

    try {
      final http.Response response = await api.project();
      final ProjectModel model =
          ProjectModel.fromJson(response.body.toString());

      Hive.box('project').put(userId, model);
      return model;
    } catch (e) {
      return ProjectModel();
    }
  }

  void notify() {
    notifyListeners();
  }
}
