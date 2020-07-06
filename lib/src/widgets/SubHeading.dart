import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  const SubHeading({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    print(this.text);
    return Text(
      text,
      style: TextStyle(
          color: Colors.black.withOpacity(.54),
          fontWeight: FontWeight.w500,
          fontSize: 14),
    );
  }
}
