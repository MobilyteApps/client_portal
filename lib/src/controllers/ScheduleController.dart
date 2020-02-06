import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ScheduleController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
        builder: (context, widget, layoutModel) {
      return Layout(model: layoutModel, content: Text(layoutModel.project.title),);
    },);
  }
}
