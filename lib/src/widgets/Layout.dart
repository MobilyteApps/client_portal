import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:client_portal_app/src/widgets/ButtonBarButton.dart';
import 'package:client_portal_app/src/widgets/EventEntryDetailPanel.dart';
import 'package:client_portal_app/src/widgets/MenuPrimary.dart';
import 'package:client_portal_app/src/widgets/MenuSecondary.dart';
import 'package:client_portal_app/src/widgets/ProjectTitle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:client_portal_app/src/widgets/LayoutDrawer.dart';

class Layout extends StatefulWidget {
  final LayoutModel model;

  final Widget content;

  final MenuPrimary primaryMenu;

  Layout({this.model, this.content, @required this.primaryMenu});

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  RightDrawerModel rightDrawerModel;

  MenuSecondary secondaryMenu = MenuSecondary();

  @override
  void initState() {
    super.initState();
    rightDrawerModel = RightDrawerModel();
  }

  bool usePortrait() {
    Size size = MediaQuery.of(context).size;
    // declare all devices with a width < 1024 to portrait
    if (size.width < 1024) {
      return true;
    }
    // use device orientation to determine,  note web should always considered landscape
    // by now,  if code execution reaches this point and we are building for web, our width is >= 1024 we are not portrait
    if (kIsWeb) {
      return false;
    }

    // use the device orientation
    Orientation orientation = MediaQuery.of(context).orientation;

    return orientation == Orientation.portrait;
  }

  Widget mobilePrimaryNav() {
    List<ButtonBarButton> buttons = [];

    widget.model.primaryMenuItems().forEach((item) {
      Icon icon = Icon(item.icon);
      Text title = Text(item.label);
      buttons.add(
        ButtonBarButton(
          icon: icon.icon,
          label: title.data,
          onPressed: () {
            widget.primaryMenu.onPressed(item.label);
          },
        ),
      );
    });

    return Container(
      color: Color.fromRGBO(0, 169, 209, 1),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: buttons,
      ),
    );
  }

  Widget desktopHeader() {
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

  Widget mobileHeader() {
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

  Widget drawer() {
    if (MediaQuery.of(context).size.width >= 1024) {
      return null;
    }
    return LayoutDrawer(
      version: '1.0',
      logo: Image.asset('images/logo.png'),
      tiles: secondaryMenu.items(context),
    );
  }

  Widget leftSidebar() {
    return Container(
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
          widget.primaryMenu,
          secondaryMenu,
        ],
      ),
    );
  }

  Scaffold scaffold(Widget child, Drawer drawer) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width >= 480 ? 480 : double.infinity,
        child: Drawer(
          child: ScopedModelDescendant<RightDrawerModel>(
            builder: (context, widget, model) {
              return model.child;
            },
          ),
        ),
      ),
      drawerScrimColor: Color.fromRGBO(50, 50, 50, 0.5),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: child,
      ),
    );
  }

  Widget portrait() {
    return Column(
      children: <Widget>[
        mobileHeader(),
        mobilePrimaryNav(),
        Expanded(
          child: Container(
            child: widget.content,
          ),
        ),
      ],
    );
  }

  Widget landscape() {
    return Container(
      padding: kIsWeb == false
          ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
          : null,
      color: kIsWeb == false ? Colors.black : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ScopedModel(
            child: leftSidebar(),
            model: widget.model.project,
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  desktopHeader(),
                  Expanded(
                    child: Container(
                      child: widget.content,
                      padding: EdgeInsets.only(top: 0, left: 60, right: 60),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Scaffold child;
    if (usePortrait()) {
      child = scaffold(
        portrait(),
        Drawer(
          child: drawer(),
        ),
      );
    } else {
      child = scaffold(landscape(), null);
    }
    

    return ScopedModel<RightDrawerModel>(
      child: child,
      model: rightDrawerModel,
    );
  }
}
