import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/controllers/ProjectLogController.dart';
import 'package:client_portal_app/src/controllers/ScheduleController.dart';
import 'package:flutter/material.dart';

import 'controllers/AppController.dart';

class AppMain extends StatefulWidget {
  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),    
      initialRoute: '/',
      routes: {
        '/': (context) => AppController(controller: ProjectLogController(),),
        '/login': (context) => LoginController(),
        '/schedule': (context) => AppController(controller: ScheduleController(),),
      },
    );
  }
}
