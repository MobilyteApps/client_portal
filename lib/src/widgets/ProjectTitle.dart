import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/ProjectModel.dart';

class ProjectTitle extends StatelessWidget {
  final String beforeTitle;

  ProjectTitle({this.beforeTitle});

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = [];

    return ScopedModelDescendant<ProjectModel>(
      builder: (context, widget, projectModel) {
        if (this.beforeTitle != null) {
          columns.add(
            Text(
              this.beforeTitle,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          );
        }

        columns.add(
          Text(
            projectModel.title,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        );

        return Container(
          height: 130,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Opacity(
                opacity: .99,
                child: Image.network(
                  projectModel.coverPhoto,
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.dstATop,
                ),
              ),
              Container(color: Color.fromRGBO(0, 0, 0, .6)),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40, left: 25, right: 25),
                  child: Column(
                    children: columns,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
