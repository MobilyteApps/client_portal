import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  static const Map<String, IconData> iconMap = {
    'fa-sun': FontAwesomeIcons.lightSun,
    'fa-clouds-sun': FontAwesomeIcons.lightCloudsSun,
    'fa-clouds': FontAwesomeIcons.lightClouds,
    'fa-cloud-drizzle': FontAwesomeIcons.lightCloudDrizzle,
    'fa-snowflake': FontAwesomeIcons.lightSnowflake,
    'fa-cloud-sleet': FontAwesomeIcons.lightCloudSleet,
    'fa-thunderstorm': FontAwesomeIcons.lightThunderstorm,
    'fa-fog': FontAwesomeIcons.lightFog,
    'fa-raindrops': FontAwesomeIcons.lightRaindrops,
  };

  Widget _weatherIcon() {
    if (this.icon == null) {
      return SizedBox();
    }
    if (iconMap.containsKey(icon)) {
      return SizedBox(
        width: 20,
        child: FaIcon(
          iconMap[icon],
          size: 16,
          color: Colors.black.withOpacity(.7),
        ),
      );
    }

    return Image.network(
      this.icon,
      height: 20,
    );
  }

  Widget _precipitation() {
    if (precipitation == null) {
      return SizedBox();
    }
    return Text(
      precipitation,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.black54,
      ),
    );
  }

  Widget _temps() {
    if (this.temperatureHigh == null || this.temperatureLow == null) {
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            temperatureHigh + '\u00b0',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Text(
            temperatureLow + '\u00b0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

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
                _precipitation(),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: VerticalDivider(
                    color: Colors.black87,
                  ),
                ),
                _weatherIcon(),
                _temps(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
