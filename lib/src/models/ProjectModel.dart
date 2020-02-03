import 'package:scoped_model/scoped_model.dart';

class ProjectModel extends Model {
  String title;
  String primaryImageUrl;

  ProjectModel({this.title, this.primaryImageUrl});

  ProjectModel.fromJson(dynamic json) {
    this.title = json['title'];
    this.primaryImageUrl = json['primaryImage'];
  }
}
