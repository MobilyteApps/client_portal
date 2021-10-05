import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfDataView extends StatelessWidget {
  String pdfName;

  PdfDataView({Key key, String this.pdfName}) : super(key: key);

  Future<String> _getConetnt() async {
    final filename = this.pdfName;
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.fileContent(this.pdfName);
    Uint8List object = response.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(object, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var padding = EdgeInsets.fromLTRB(5, 10, 5, 10);

          return Container(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: PDFView(
                    filePath: snapshot.data,
                    preventLinkNavigation: true,
                    fitEachPage: true,
                    fitPolicy: FitPolicy.HEIGHT,
                  )));
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
