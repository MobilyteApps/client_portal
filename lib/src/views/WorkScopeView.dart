import 'dart:convert';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WorkScopeView extends StatelessWidget {
  const WorkScopeView({Key key}) : super(key: key);

  Future<String> _getConetnt() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.workScope();
    Map<String, dynamic> object= json.decode(response.body);
    String content= object['content'];
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var padding = EdgeInsets.fromLTRB(5, 10, 5, 10);

          return SingleChildScrollView(child:Padding(
            child: Html(data:snapshot.data),
            padding: padding,
          ));
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
