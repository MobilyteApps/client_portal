import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItem {
  MenuItem({@required this.icon, @required this.label,this.fIcons});

  final IconData icon;
  final String label;
  final FontAwesomeIcons fIcons;
}
