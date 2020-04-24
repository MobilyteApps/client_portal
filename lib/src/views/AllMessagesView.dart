import 'package:flutter/material.dart';

class AllMessagesView extends StatefulWidget {
  AllMessagesView({Key key}) : super(key: key);

  @override
  _AllMessagesViewState createState() => _AllMessagesViewState();
}

class _AllMessagesViewState extends State<AllMessagesView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('all messages'),
    );
  }
}
