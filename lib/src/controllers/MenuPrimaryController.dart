import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/MenuItem.dart';
import 'package:client_portal_app/src/views/ProjectLogView.dart';
import 'package:client_portal_app/src/views/ScheduleView.dart';
import 'package:client_portal_app/src/widgets/Layout.dart';
import 'package:client_portal_app/src/widgets/MenuPrimary.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MenuPrimaryController extends StatefulWidget {
  MenuPrimaryController({Key key}) : super(key: key);

  @override
  _MenuPrimaryControllerState createState() => _MenuPrimaryControllerState();
}

class _MenuPrimaryControllerState extends State<MenuPrimaryController> {
  Widget content = Expanded(
    flex: 1,
    child: Center(
      heightFactor: 12,
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    content = switchContent('Project Log');
    super.initState();
  }

  Widget switchContent(String identifier) {
    switch (identifier) {
      case 'Project Log':
        return ProjectLogView();
      case 'Schedule':
        return ScheduleView();
      default:
        return Text("$identifier not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LayoutModel>(
      builder: (context, widget, model) {
        List<MenuItem> tiles = model.primaryMenuItems();
        MenuPrimary primaryMenu = MenuPrimary(
          items: tiles,
          onPressed: (String identifier) {
            setState(() {
              content = switchContent(identifier);
            });
          },
        );

        return Layout(
          primaryMenu: primaryMenu,
          model: model,
          content: Container(
            child: content,
          ),
        );
      },
    );
  }
}
