import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/MenuItem.dart';
import 'package:client_portal_app/src/models/ProjectModel.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LayoutModel extends Model {
  final UserModel identity;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  ProjectModel project;

  Widget endDrawer;

  LayoutModel({this.identity, this.project});

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<MenuItem> primaryMenuItems() {
    return [
      MenuItem(icon: Icons.library_books, label: 'Project Log'),
      MenuItem(icon: Icons.event_note, label: 'Schedule'),
      MenuItem(icon: Icons.message, label: 'Messages'),
      // MenuItem(icon: Icons.notifications, label: 'Notifications')
    ];
  }

  void setEndDrawer(Widget drawer) {
    endDrawer = drawer;
    notifyListeners();
  }

  void setProject(ProjectModel project) {
    this.project = project;
    notifyListeners();
  }

  void saveDeviceToken() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var token = await firebaseMessaging.getToken();
    await api.saveDeviceToken(token);
  }
}
