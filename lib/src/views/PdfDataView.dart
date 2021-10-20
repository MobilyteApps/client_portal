
import 'dart:typed_data';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PdfDataView extends StatelessWidget {
  String pdfName;

  PdfDataView({Key key, String this.pdfName}) : super(key: key);

  Future<Uint8List> _getConetnt() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.fileContent(this.pdfName);
    Uint8List object = response.bodyBytes;
    return object;
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
                  child: kIsWeb?SfPdfViewer.memory(
                    snapshot.data,
                    initialZoomLevel: 1.12,
                    enableDoubleTapZooming: true,
                    canShowScrollStatus: true,
                    canShowScrollHead: true,
                    scrollDirection: PdfScrollDirection.vertical,
                    interactionMode: PdfInteractionMode.pan,
                    initialScrollOffset: Offset.zero,

                  ): PDFView(pdfData: snapshot.data,
                  fitPolicy: FitPolicy.HEIGHT,
                    fitEachPage: true,
                    preventLinkNavigation: true,
                  ),));
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
