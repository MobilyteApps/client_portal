import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:scoped_model/scoped_model.dart';

class LayoutModel extends Model {
  final UserModel identity;
  final ProjectModel project;

  LayoutModel({this.identity, this.project});
}
