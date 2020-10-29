import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  const TextHeading({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
