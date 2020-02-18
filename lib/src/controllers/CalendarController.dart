import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/PanelLayout.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CalendarController extends StatelessWidget {
  const CalendarController({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, layoutModel) {
        return PanelLayout(
          model: layoutModel,
          content: Text(layoutModel.project.title + ' Calendar'),
        );
      },
    );
  }
}