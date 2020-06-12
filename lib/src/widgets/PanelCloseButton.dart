import 'package:flutter/material.dart';

class PanelCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
