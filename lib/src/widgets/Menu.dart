import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  final List<Widget> items;
  final Color backgroundColor;
  Menu({this.items, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(      
      decoration: BoxDecoration(color: this.backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }
}
