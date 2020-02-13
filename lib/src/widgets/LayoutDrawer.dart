import 'package:flutter/material.dart';

class LayoutDrawer extends StatelessWidget {
  const LayoutDrawer(
      {Key key, @required this.logo, @required this.version, this.tiles})
      : super(key: key);

  final Image logo;

  final String version;

  final List<ListTile> tiles;

  Widget header() {
    return DrawerHeader(
      decoration: BoxDecoration(color: Color.fromRGBO(231, 231, 231, 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: logo,
            height: 51,
            padding: EdgeInsets.only(bottom: 7),
          ),
          Text(
            'Version $version',
            style: TextStyle(
              fontSize: 10,
              color: Color.fromRGBO(142, 142, 142, 1),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> items() {
    List<Widget> items = [];

    items.add(header());

    tiles.forEach((tile) {
      items.add(tile);
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        child: ListView(
          children: items(),
        ),
      ),
    );
  }
}
