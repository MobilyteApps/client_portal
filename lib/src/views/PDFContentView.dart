import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PDFContentView extends StatelessWidget {
  final Uint8List pdfData;

  const PDFContentView({Key key, this.pdfData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _padding = EdgeInsets.only(top: 0, left: 0, right: 0);
    if (MediaQuery.of(context).size.width < 1024) {
      _padding = EdgeInsets.all(20);
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: _padding,
      child: _pdfView(),
    );
  }

  Widget _pdfView() {
    return PdfView(
      scrollDirection: Axis.vertical,
      pageSnapping: true,
      controller: PdfController(
          document: PdfDocument.openData(this.pdfData), initialPage: 0),
    );
  }
}
