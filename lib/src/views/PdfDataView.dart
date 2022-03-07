import 'dart:typed_data';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/PanelCloseButton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfDataView extends StatelessWidget {
  String pdfName;
  Function onGetFile;

  PdfDataView({Key key, String this.pdfName, this.onGetFile}) : super(key: key);

  var data;

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
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              elevation: 0,
              title: Text(pdfName),
              actions: [
                PopupMenuButton(
                  // icon: Icon(
                  //     Icons.menu), //don't specify icon if you want 3 dot menu
                  color: Colors.white,
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: InkWell(
                        child: Text(
                          "Print",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                  onSelected: (item) async {
                    await Printing.layoutPdf(
                        onLayout: (format) async => snapshot.data);
                    // document.buffer.asUint8List());
                  },
                ),
              ],
              leading: PanelCloseButton(),
            ),
            body: Container(
                child: Padding(
              padding: EdgeInsets.all(10),
              child: kIsWeb
                  ? SfPdfViewer.memory(
                      snapshot.data,
                      initialZoomLevel: 1.12,
                      enableDoubleTapZooming: true,
                      canShowScrollStatus: true,
                      canShowScrollHead: true,
                      scrollDirection: PdfScrollDirection.vertical,
                      interactionMode: PdfInteractionMode.pan,
                      initialScrollOffset: Offset.zero,
                    )
                  : PDFView(
                      pdfData: snapshot.data,
                      fitPolicy: FitPolicy.HEIGHT,
                      fitEachPage: true,
                      preventLinkNavigation: true,
                    ),
            )),
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
