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
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: color,
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
