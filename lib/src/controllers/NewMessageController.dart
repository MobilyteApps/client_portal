import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:client_portal_app/src/views/NewMessageView.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class NewMessageController extends ResponsiveController {
  NewMessageController()
      : super(panelCenterTitle: true, panelLayoutTitle: 'New Message');

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return FutureBuilder(
      future: _getTeam(),
      builder: (context, AsyncSnapshot<List<PersonModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return NewMessageView(
            team: snapshot.data,
          );
        }

        return Container();
      },
    );
  }

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
}
