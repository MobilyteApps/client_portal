import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonBarButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  ButtonBarButton(
      {this.onPressed, this.icon, this.label, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width*0.16000,
        height: 55,
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: color,
            ),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
