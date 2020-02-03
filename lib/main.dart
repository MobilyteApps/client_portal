import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'src/controllers/AppController.dart';
import 'src/models/UserModel.dart';

void main() => runApp(MyApp());

// App Flow SplashCreen -> Welcome

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        title: 'Client Portal',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AppController(),
      ),
    );
  }
}
