import 'package:flutter/material.dart';

class BackButtonHeading extends StatelessWidget {
  const BackButtonHeading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.arrow_back),
          Text(
            'Back',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
