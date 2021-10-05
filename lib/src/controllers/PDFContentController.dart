import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/ContentView.dart';
import 'package:client_portal_app/src/views/PDFContentView.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:flutter/material.dart';
import 'ResponsiveController.dart';


class PDFContentController extends ResponsiveController {
  String pdfFileName;

  PDFContentController({Key key, String this.pdfFileName}) : super(key: key);


  Future<Uint8List> _getConetnt() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.fileContent(this.pdfFileName);
    Uint8List object = response.bodyBytes;
    return object;
  }

  @override
  Widget buildContent(LayoutModel layoutModel,BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          EdgeInsets titlePadding =
          EdgeInsets.only(top: 30, left: 30, right: 30);

          return  Padding(
            padding: EdgeInsets.only(left: 40, top: 30, right: 0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: BackButtonHeading(),
                ),
                Container(
                  child: Text(
                    this.pdfFileName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  padding: titlePadding,
                ),
                 PDFContentView(pdfData: snapshot.data,)
              ],
            ),
          );
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
