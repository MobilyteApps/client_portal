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
      padding: EdgeInsets.only(left: 0, right: 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      onPressed: onPressed,
      color: backgroundColor,
      textColor: textColor,
      child: child,
    );
  }
}
