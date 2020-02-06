import 'package:flutter/material.dart';

class ProjectLogHeader extends StatelessWidget {
  const ProjectLogHeader({Key key, @required this.title, this.precipitation, this.temperatureHigh, this.temperatureLow, this.icon}) : super(key: key);

  final String title;

  final String precipitation;

  final String temperatureHigh;

  final String temperatureLow;

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(color: Color.fromRGBO(238, 238, 238, 1)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(this.title),
          )
        ],
      ),
    );
  }
}
