import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/views/TeamView.dart';
import 'package:client_portal_app/src/widgets/MyCustomScrollBehaviour.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class TeamController extends ResponsiveController {
  TeamController()
      : super(panelLayoutTitle: 'My Mosby Team', panelCenterTitle: true);

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    ScrollController _scrollController= ScrollController();
    return ScrollConfiguration(behavior:  MyCustomScrollBehaviour(), child: Padding(
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          Text('My Mosby Team', style: Theme.of(context).textTheme.headline6,),
          TeamView(),
        ],
      ),
      padding: EdgeInsets.only(top: 50, left: 60, right: 60),
    ));

  }

  Widget buildContentPanel(LayoutModel layoutModel, BuildContext context) {
    return TeamView();
  }
}
