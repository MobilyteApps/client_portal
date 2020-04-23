import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/controllers/NewMessageController.dart';
import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class TeamController extends ResponsiveController {
  TeamController()
      : super(panelLayoutTitle: 'Your Mosby Team', panelCenterTitle: true);

  Future<List<PersonModel>> _getTeam() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      PersonModel(
          name: 'Jill Huckelberry',
          avatar: '',
          title: 'PROJECT MANAGER',
          id: 'jh'),
      PersonModel(
          name: 'Michael Ford', avatar: '', title: 'LEAD REMODELER', id: 'mf'),
      PersonModel(name: 'Kyle Royer', avatar: '', title: 'LABORER', id: 'kr'),
    ];
  }

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          bottom: BorderSide(
                              color: Colors.black.withOpacity(.12)))),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        child: Text('sc'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(snapshot.data[index].name),
                            Text(snapshot.data[index].title),
                          ],
                        ),
                      ),
                      FlatButton(
                        color: Brand.primary,
                        child: Text(
                          'Message'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          if (MediaQuery.of(context).size.width >= 1024) {
                            Navigator.pushNamed(context, '/new-message',
                                arguments: snapshot.data[index]);
                          } else {
                            Navigator.push(
                              context,
                              SlideUpRoute(
                                settings: RouteSettings(
                                    arguments: snapshot.data[index]),
                                page: AppController(
                                  controller: NewMessageController(),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                );
              },
              itemCount: snapshot.data.length,
            ),
            padding: EdgeInsets.only(top: 20),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: LinearProgressIndicator(),
        );
      },
      future: _getTeam(),
    );
  }
}
