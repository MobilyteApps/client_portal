import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/views/TeamView.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class TeamController extends ResponsiveController {
  TeamController()
      : super(panelLayoutTitle: 'Your Mosby Team', panelCenterTitle: true);

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[        
          Text('Your Mosby Team', style: Theme.of(context).textTheme.headline6,),
          TeamView(),
        ],
      ),
      padding: EdgeInsets.only(top: 50, left: 60, right: 60),
    );
  }

  Widget buildContentPanel(LayoutModel layoutModel, BuildContext context) {
    return TeamView();
  }
}
