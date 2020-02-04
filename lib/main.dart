import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'src/controllers/AppController.dart';
import 'src/models/UserModel.dart';

void main() async {
  if (kIsWeb == false) {
    final appDocumentDirectory =
        await pathProvider.getApplicationDocumentsDirectory();

    Hive.init(appDocumentDirectory.path);
  }
  Hive.registerAdapter(UserModelAdapter());
  runApp(MyApp());
}

// App Flow SplashCreen -> Welcome

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
