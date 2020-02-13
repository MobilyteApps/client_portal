import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/ButtonBarButton.dart';
import 'package:client_portal_app/src/widgets/MenuPrimary.dart';
import 'package:client_portal_app/src/widgets/MenuSecondary.dart';
import 'package:client_portal_app/src/widgets/ProjectTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:client_portal_app/src/widgets/LayoutDrawer.dart';

class Layout extends StatefulWidget {
  final LayoutModel model;

  final Widget content;

  Layout({this.model, this.content});

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  MenuSecondary secondaryMenu = MenuSecondary();

  MenuPrimary primaryMenu = MenuPrimary();

  Widget mobilePrimaryNav(BuildContext context) {
    List<ButtonBarButton> buttons = [];

    primaryMenu.items(context).forEach((item) {
      Icon icon = item.leading;
      Text title = item.title;
      buttons.add(
        ButtonBarButton(
          icon: icon.icon,
          label: title.data,
          onPressed: item.onTap,
        ),
      );
    });

    if (MediaQuery.of(context).size.width > 1024) {
      return Container();
    }
    return Container(
      color: Color.fromRGBO(0, 169, 209, 1),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: buttons,
      ),
    );
  }

  Widget desktopHeader(BuildContext context) {
    if (MediaQuery.of(context).size.width < 1024) {
      return Container();
    }

    return Container(
      height: 130,
      decoration: BoxDecoration(color: Color.fromRGBO(231, 231, 231, 1)),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 60),
        child: Image.asset('images/logo.png'),
        constraints: BoxConstraints.expand(),
      ),
    );
  }

  Widget mobileHeader(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1024) {
      return Container();
    }

    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: <Widget>[
          ScopedModel(
            model: widget.model.project,
            child: ProjectTitle(
              beforeTitle: 'My',
              height: 175,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            width: 45,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget drawer(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1024) {
      return null;
    }
    return LayoutDrawer(
      version: '1.0',
      logo: Image.asset('images/logo.png'),
      tiles: secondaryMenu.items(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget sidebar = Container(
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
          primaryMenu,
          secondaryMenu,
        ],
      ),
    );

    if (MediaQuery.of(context).size.width < 1024) {
      sidebar = Container();
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(context),
      drawerScrimColor: Color.fromRGBO(50, 50, 50, 0.5),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ScopedModel(
              child: sidebar,
              model: widget.model.project,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    mobileHeader(context),
                    mobilePrimaryNav(context),
                    desktopHeader(context),
                    Padding(
                      child: widget.content,
                      padding: EdgeInsets.all(60),
                    ),
                  ],
                ),
                decoration: BoxDecoration(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
