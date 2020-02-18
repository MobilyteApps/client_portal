import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RightDrawerModel extends Model {
  
  Widget child = Container();

  setContent(Widget content) {
    child = content;
    notifyListeners();
  }
}
