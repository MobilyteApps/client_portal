import 'package:flutter/material.dart';

class EventEntry extends StatelessWidget {
  const EventEntry({Key key, this.backgroundColor, this.textColor})
      : super(key: key);

  final Color backgroundColor;

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Text('Event Entry'),
    );
  }
}
