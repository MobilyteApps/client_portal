import 'package:client_portal_app/src/controllers/LoginController.dart';
import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/MenuPrimary.dart';
import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

import '../widgets/MenuSecondary.dart';
import '../widgets/ProjectTitle.dart';
import '../models/ProjectModel.dart';
import '../Api.dart';

class ProjectLogController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, widget, model) {
        Widget content = Column(
          children: <Widget>[
            Text('Hello ${model.username}, this is the content'),
            FlatButton(
              child: Text('sign out'),
              onPressed: () async {
                await model.logout();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => LoginController()));
              },
            ),
          ],
        );

        final Api api = Api(baseUrl: Config.apiBaseUrl);

        return Scaffold(
          body: FutureBuilder(
              future: api.project(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Row();
                }

                if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                }

                ProjectModel model = ProjectModel.fromJson(snapshot.data.body);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ScopedModel(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(250, 250, 250, 1),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.18),
                                offset: Offset.fromDirection(5, 5)),
                          ],
                        ),
                        width: 300,
                        child: Column(
                          children: <Widget>[
                            ProjectTitle(beforeTitle: 'My'),
                            MenuPrimary(),
                            MenuSecondary(),
                          ],
                        ),
                      ),
                      model: model,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 130,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(231, 231, 231, 1)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 60),
                                child: Image.asset('images/logo.png'),
                                constraints: BoxConstraints.expand(),
                              ),
                            ),
                            Padding(
                              child: content,
                              padding: EdgeInsets.all(60),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }
}
