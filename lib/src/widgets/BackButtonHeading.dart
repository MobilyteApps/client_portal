import 'package:flutter/material.dart';

class BackButtonHeading extends StatelessWidget {
  const BackButtonHeading({Key key}) : super(key: key);
//common back button
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.arrow_back),
          SizedBox(
            width: 10,
          ),
          Text(
            'Back',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
