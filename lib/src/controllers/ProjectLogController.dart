import 'package:client_portal_app/src/models/UserModel.dart';
import 'package:client_portal_app/src/widgets/MenuPrimary.dart';
import '../widgets/MenuSecondary.dart';
import "package:flutter/material.dart";
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ProjectTitle.dart';
import '../models/ProjectModel.dart';

class ProjectLogController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, widget, model) {
        Widget content = Text('this is the content');

        return Scaffold(
          body: Row(        
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ScopedModel(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.18),
                          offset: Offset.fromDirection(5, 5)),
                    ],
                  ),
                  width: 300,
                  child: Column(
                    children: <Widget>[
                      ProjectTitle(beforeTitle: 'My'),
                      MenuPrimary(),
                      MenuSecondary(),
                    ],
                  ),
                ),
                model: ProjectModel(
                    title: 'Kitchen Remodel',
                    primaryImageUrl:
                        "https://ashleyfurniture.scene7.com/is/image/AshleyFurniture/D583-25-02%284%29-00-59"),
              ),
              Expanded(
                flex: 1, 
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,                    
                    children: <Widget>[
                      Container(
                        height: 130,                        
                        decoration: BoxDecoration(color: Color.fromRGBO(231, 231, 231, 1)),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 60),
                          child: Image.asset('images/logo.png'), 
                          constraints: BoxConstraints.expand(),                          
                        ),
                      ),
                      Padding(child: content, padding: EdgeInsets.all(60),),                      
                    ],
                  ), 
                  decoration: BoxDecoration(
                    color: Colors.white
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
