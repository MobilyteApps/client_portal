import 'package:client_portal_app/src/models/MenuItem.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Menu.dart';

class MenuPrimary extends StatelessWidget {
  MenuPrimary({this.onPressed, this.items});

  final TextStyle textStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  final void Function(String) onPressed;

  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = [];

    items.forEach((item) {
      tiles.add(
        ListTile(
          leading:item.label== "My Project Work"? FaIcon(item.icon,color: Colors.white,size: 22,):Icon(
            item.icon,
            color: Colors.white,
            size: 25,
          ),
          title: Text(
            item.label,
            style: TextStyle(
              color: Colors.white,
              fontSize:item.label== "My Project Work"? 15.36:16,
            ),
          ),
          onTap: () {
            onPressed(item.label);
          },
        ),
      );
    });

    return Menu(
      backgroundColor: Color.fromRGBO(0, 169, 209, 1),
      items: tiles,
    );
  }
}
