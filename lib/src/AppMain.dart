import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hive/hive.dart';

import 'controllers/AppController.dart';
import 'models/UserModel.dart';

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
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            UserModel identity = Hive.box('identity').get(0);
            return ScopedModel<UserModel>(
              model: identity == null ? UserModel() : identity,
              child: MaterialApp(
                title: 'Client Portal',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: AppController(),
              ),
            );
          }
        } else {
          return MaterialApp(
            theme: ThemeData(primarySwatch: Colors.blue),
            home: Text(''),
          );
        }
      },
      future: Hive.openBox('identity'),
    );
  }
}
