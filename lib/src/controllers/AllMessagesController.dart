import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/controllers/NewMessageController.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/views/AllMessagesView.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:client_portal_app/src/widgets/MyCustomScrollBehaviour.dart';
import 'package:flutter/material.dart';
import 'package:client_portal_app/src/controllers/ResponsiveController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';

class AllMessagesController extends ResponsiveController {
  AllMessagesController()
      : super(
          panelLayoutTitle: 'Messages',
          panelCenterTitle: true,
        );

  @override
  AppBar buildAppBar(BuildContext context) {
    var appBar = super.buildAppBar(context);
    appBar.actions.add(
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          if (MediaQuery.of(context).size.width >= 1024) {
            Navigator.pushNamed(context, '/new-message');
          } else {
            Navigator.push(
              context,
              SlideUpRoute(
                settings: RouteSettings(),
                page: AppController(
                  controller: NewMessageController(),
                  requiresAuth: true,
                ),
              ),
            );
          }
        },
      ),
    );
    return appBar;
  }

  @override
  Widget buildContentPanel(LayoutModel layoutModel, BuildContext context) {
    return AllMessagesView(
      layoutModel: layoutModel,
    );
  }

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    ScrollController _scrollController= ScrollController();
    return ScrollConfiguration(behavior: MyCustomScrollBehaviour(), child:  Padding(
      padding: EdgeInsets.only(top: 50, left: 60, right: 60),
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          BackButtonHeading(),
          SizedBox(
            height: 30,
          ),
          Text(
            'Messages',
            style: Theme.of(context).textTheme.headline6,
          ),
          Expanded(
            child: AllMessagesView(
              layoutModel: layoutModel,
            ),
          ),
        ],
      ),
    ));

  }
}
