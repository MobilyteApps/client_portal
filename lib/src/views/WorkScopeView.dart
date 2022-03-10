import 'dart:convert';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'ContentView.dart';

class WorkScopeView extends StatelessWidget {
  const WorkScopeView({Key key}) : super(key: key);

  Future<String> _getConetnt() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.workScope();
    Map<String, dynamic> object = json.decode(response.body);
    String content = object['content'];
    return content;
  }

  Widget heading(context) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            'My Project Work',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          EdgeInsets padding = EdgeInsets.only(top: 4, left: 10, right: 15);
          if (MediaQuery.of(context).size.width >= 1024) {
            padding = padding.copyWith(left: 60, right: 60, bottom: 0, top: 20);
          }
          return kIsWeb && MediaQuery.of(context).size.width >= 1024 ?Column(
            children: [
              Padding(padding: padding, child: heading(context)),
              Container(
                child: ContentView(
                  html: snapshot.data,
                ),
              ),
            ],
          ):ListView(
            children: [
              Padding(padding: padding, child: heading(context)),
              Container(
                color: Colors.white,
                child: ContentView(
                  html: snapshot.data,
                ),
              ),
            ],
          );;
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        );
      },
      future: _getConetnt(),
    );
  }
}
