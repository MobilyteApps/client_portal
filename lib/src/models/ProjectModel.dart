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

  ProjectModel({this.title, this.coverPhoto});

  ProjectModel.fromJson(dynamic body) {
    dynamic j = json.decode(body);
    this.title = j['title'];
    this.coverPhoto = j['coverPhoto'];
  }
}
