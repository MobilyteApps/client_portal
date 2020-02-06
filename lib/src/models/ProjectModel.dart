import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';

class ProjectModel extends Model {
  String title;
  String coverPhoto;

  ProjectModel({this.title, this.coverPhoto});

  ProjectModel.fromJson(dynamic body) {
    dynamic j = json.decode(body);
    this.title = j['title'];
    this.coverPhoto = j['coverPhoto'];
  }
}
