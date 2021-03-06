import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:client_portal_app/src/transitions/SlideUpRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/BillingAndPaymentsView.dart';
import 'package:client_portal_app/src/views/WorkScopeView.dart';
import 'package:client_portal_app/src/widgets/ButtonBarButton.dart';
import 'package:client_portal_app/src/widgets/MenuPrimary.dart';
import 'package:client_portal_app/src/widgets/MenuSecondary.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:client_portal_app/src/widgets/ProjectTitle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:client_portal_app/src/widgets/LayoutDrawer.dart';

class Layout extends StatefulWidget {
  final LayoutModel model;

  final Widget content;

  final String version = '0.0.25.0';

  Layout({this.model, this.content});

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  RightDrawerModel rightDrawerModel;

  MenuSecondary secondaryMenu;

  MenuPrimary menuPrimary;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scaffoldKey = widget.model.scaffoldKey as GlobalKey<ScaffoldState>;
    rightDrawerModel = RightDrawerModel();
    menuPrimary = MenuPrimary(
      items: widget.model.primaryMenuItems(),
      onPressed: onPressPrimaryMenu,
    );
    secondaryMenu = MenuSecondary(
      layoutModel: widget.model,
      textStyle: TextStyle(
        fontSize: 14,
      ),
    );
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

  void onPressPrimaryMenu(identifier) {
    switch (identifier) {
      case 'Schedule':
        Navigator.pushReplacementNamed(context, '/schedule');
        break;
      case 'Project Log':
        Navigator.pushNamed(context, '/');
        break;
      case 'Messages':
        Navigator.pushNamed(context, '/messages');
        break;
      case 'My Project Work':
        Navigator.pushNamed(context, '/work-scope');
        break;
      case 'Billing and Payments':
        print('billing');
        var width = MediaQuery.of(context).size.width;
        if (width >= 1024) {
          Navigator.pushNamed(context, '/billing');
        } else {
          Navigator.push(
            context,
            SlideUpRoute(
              settings: RouteSettings(),
              page: PanelScaffold(
                title: 'Billing & Payments',
                body: BillingAndPaymentsView(layoutModel: widget.model),
              ),
            ),
          );
        }
        break;
    }
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
            onPressPrimaryMenu(item.label);
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
      decoration: BoxDecoration(color: Color.fromRGBO(231, 231, 231, 1)),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 60),
        child: Image.asset('images/logo.png'),
        constraints: BoxConstraints.expand(),
      ),
    );
  }

  Widget logo() {
    return Image.asset(
      'images/logo.png',
      height: 55,
      alignment: Alignment.centerLeft,
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
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState.showBottomSheet(
                  (context) => Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(_scaffoldKey.currentState.context)
                          .viewPadding
                          .top,
                    ),
                    child: LayoutDrawer(
                      version: widget.version,
                      logo: Image.asset('images/logo.png'),
                      tiles: secondaryMenu.items(context),
                    ),
                  ),
                );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ProjectTitle(beforeTitle: 'My'),
          menuPrimary,
          secondaryMenu,
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 10, left: 20),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Version ${widget.version}',
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromRGBO(142, 142, 142, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget endDrawer() {
    return Container(
      width: MediaQuery.of(context).size.width >= 480 ? 480 : double.infinity,
      child: Drawer(
        child: ScopedModelDescendant<RightDrawerModel>(
          builder: (context, widget, model) {
            return model.child;
          },
        ),
      ),
    );
  }

  Scaffold scaffold(Widget child, Drawer drawer) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer,
      endDrawer: endDrawer(),
      drawerScrimColor: Color.fromRGBO(50, 50, 50, 0.5),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: child,
      ),
    );
  }

  Widget portrait() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    return LayoutBuilder(builder: (context, constraint) {
      return ScrollConfiguration(
        behavior: null,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: IntrinsicHeight(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScopedModel(
                child: Material(
                  child: leftSidebar(),
                ),
                model: widget.model.project,
              ),
              VerticalDivider(
                width: 1,
                color: Colors.black54,
              ),
              Expanded(
                  child: Scaffold(
                endDrawer: endDrawer(),
                drawerScrimColor: Color.fromRGBO(50, 50, 50, 0.5),
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  child: desktopHeader(),
                  preferredSize: Size.fromHeight(130),
                ),
                body: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .455),
                      child: Container(
                          child: backgroundColumn()),

                    ),
                    ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width *.36),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 740),
                            child: widget.content,
                            width: 740,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ],
          ))),
        ),
      );
    });
  }

  Widget backgroundColumn() {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.centerRight,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Opacity(
            opacity: .99,
            child: Image.asset(
              'images/login-bg_compressed.jpg',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.white.withOpacity(.73),
                Colors.white.withOpacity(0),
              ], stops: [
                0,
                .48,
                1
              ]),
            ),
          ),
        ),
        Text('')


      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (usePortrait()) {
      child = scaffold(
        portrait(),
        Drawer(
          child: drawer(),
        ),
      );
    } else {
      //child = scaffold(landscape(), null);
      child = landscape();
    }

    return ScopedModel<RightDrawerModel>(
      child: child,
      model: rightDrawerModel,
    );
  }
}
