import 'package:flutter/material.dart';

class CommomButton extends StatelessWidget{
  final String title;
  final Function onValueCahnged;

  const CommomButton({@required this.title, Key key, @required Function this.onValueCahnged}):
    super(key:key);


  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onValueCahnged, child: Text(title));
    // TODO: implement build
    throw UnimplementedError();
  }



}