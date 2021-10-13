import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFContentView extends StatelessWidget {
  final Uint8List pdfData;

  const PDFContentView({Key key, this.pdfData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _padding = EdgeInsets.only(top: 0, left: 0, right: 0);
    if (MediaQuery.of(context).size.width < 1024) {
      _padding = EdgeInsets.all(0);
    }
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      padding: _padding,
      child: _pdfView(),
    );
  }
  Widget _pdfView() {
    return SfPdfViewer.memory(
      this.pdfData ,
      initialZoomLevel: 1.15,
      enableDoubleTapZooming: true,
      canShowScrollStatus: true,
      canShowScrollHead: true,
       scrollDirection: PdfScrollDirection.vertical,
      interactionMode: PdfInteractionMode.pan,
    );

  }
}
