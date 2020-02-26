import 'package:flutter/material.dart';

class LayoutDrawer extends StatelessWidget {
  const LayoutDrawer(
      {Key key, @required this.logo, @required this.version, this.tiles})
      : super(key: key);

  final Image logo;

  final String version;

  final List<Widget> tiles;

  Widget header() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 15, right: 15),
      height: 187,
      decoration: BoxDecoration(color: Color.fromRGBO(231, 231, 231, 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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

  List<Widget> items(context) {
    List<Widget> items = [];

    tiles.forEach((tile) {
      items.add(tile);
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black12),
              ),
            ),
            child: ListTile(
              leading: IconButton(
                constraints: BoxConstraints(maxWidth: 20),
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: items(context),
            ),
          ),
          header()
        ],
      ),
    );
  }
}
