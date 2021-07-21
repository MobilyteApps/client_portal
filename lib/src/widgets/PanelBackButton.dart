import 'package:flutter/material.dart';

class PanelBackButton extends StatelessWidget {
  const PanelBackButton({Key key}) : super(key: key);
// back button for panel
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
