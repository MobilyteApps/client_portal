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

  // static Map<String, IconData> iconMap = {
  //   'fa-sun': FontAwesomeIcons.accusoft,        //lightSun,
  //   'fa-clouds-sun': FontAwesomeIcons.lightbulb,        //lightCloudsSun,
  //   'fa-clouds': FontAwesomeIcons.solidLightbulb ,              //lightClouds,
  //   'fa-cloud-drizzle': FontAwesomeIcons.cloudRain,         //lightCloudDrizzle,
  //   'fa-snowflake': FontAwesomeIcons.snowflake ,          //lightSnowflake,
  //   'fa-cloud-sleet': FontAwesomeIcons.cloudscale ,      //lightCloudSleet,
  //   'fa-thunderstorm': FontAwesomeIcons.pooStorm,      //lightThunderstorm,
  //   'fa-fog': FontAwesomeIcons.fastBackward,    //lightFog,
  //   'fa-raindrops': FontAwesomeIcons.flask     //lightRaindrops,
  // };

  static Map<String, String> iconMap = {
    'fa-sun': 'images/009-sun.png', //lightSun,  '
    'fa-clouds-sun': 'images/003-cloudy.png', //lightCloudsSun,
    'fa-clouds': 'images/006-cloud.png', //lightClouds,
    'fa-cloud-drizzle': 'images/004-storm.png', //lightCloudDrizzle,
    'fa-snowflake': 'images/001-snowing.png', //lightSnowflake,
    'fa-cloud-sleet': 'images/cloudsheet.png', //lightCloudSleet,
    'fa-thunderstorm': 'images/004-storm.png', //lightThunderstorm,
    'fa-fog': 'images/010-fog.png', //lightFog,
    'fa-raindrops': 'images/005-raining.png' //lightRaindrops,
  };

  Widget _weatherIcon() {
    if (this.icon == null) {
      return SizedBox();
    }
    if (iconMap.containsKey(icon)) {
   //   print("==========================${icon}");
      return SizedBox(
        width: 20,
        child: Image.asset(iconMap[icon],
            height: 16, width: 16), // child: FaIcon(               //
        //   iconMap[icon],
        //   size: 16,
        //   color: Colors.black.withOpacity(.7),
        // ),
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
