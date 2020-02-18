import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventEntry extends StatelessWidget {
  const EventEntry(
      {Key key,
      @required this.backgroundColor,
      @required this.textColor,
      @required this.title,
      this.trailing,
      this.onTap,
      this.startDateTime,
      this.endDateTime,
      this.location,
      this.description})
      : super(key: key);

  final int backgroundColor;
  final int textColor;
  final String title;
  final String trailing;
  final String startDateTime;
  final String endDateTime;
  final String location;
  final String description;
  final void Function(EventEntry) onTap;

  String date() {
    final DateFormat dateFormat = DateFormat('MMMM d, y');
    return startDateTime == null
        ? ''
        : dateFormat.format(DateTime.parse(startDateTime));
  }

  String time() {
    final DateFormat timeFormat = DateFormat.jm();
    if (startDateTime == null) {
      return '';
    }

    if (endDateTime == null) {
      return timeFormat.format(DateTime.parse(startDateTime));
    }

    // both start and end dates are specified
    var start = timeFormat.format(DateTime.parse(startDateTime));
    var end = timeFormat.format(DateTime.parse(endDateTime));

    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 60),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Color(backgroundColor),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: () {
          onTap(this);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Color(textColor),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            trailing != null
                ? Text(
                    trailing,
                    style: TextStyle(
                      color: Color(textColor).withOpacity(.7),
                      fontSize: 14,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
