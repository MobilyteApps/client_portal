import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {Key key,
      this.child,
      this.onPressed,
      this.backgroundColor,
      this.textColor})
      : super(key: key);

  final Widget child;

  final VoidCallback onPressed;

  final Color backgroundColor;

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: CircleBorder(
        side: BorderSide(color: backgroundColor),
      ),
      onPressed: onPressed,
      color: backgroundColor,
      textColor: textColor,
      child: child,
    );
  }
}
