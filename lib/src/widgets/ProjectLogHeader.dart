import 'package:flutter/material.dart';

class ProjectLogHeader extends StatelessWidget {
  const ProjectLogHeader(
      {Key key,
      @required this.title,
      this.precipitation,
      this.temperatureHigh,
      this.temperatureLow,
      this.icon})
      : super(key: key);

  final String title;

  final String precipitation;

  final String temperatureHigh;

  final String temperatureLow;

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(color: Color.fromRGBO(238, 238, 238, 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              this.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 0,
            child: Row(
              children: <Widget>[
                Text(
                  '20%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: VerticalDivider(
                    color: Colors.black87,
                  ),
                ),
                Image.network(
                  this.icon,
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '35\u00b0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '27\u00b0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
