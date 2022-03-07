import 'dart:typed_data';
import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/PDFContentView.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'ResponsiveController.dart';

class PDFContentController extends ResponsiveController {
  final String title;
  final String filename;

  const PDFContentController({Key key, String this.title, String this.filename})
      : super(key: key);

  Future<Uint8List> _getConetnt() async {
    var api = Api(baseUrl: Config.apiBaseUrl);
    var response = await api.fileContent(this.filename);
    Uint8List object = response.bodyBytes;
    return object;
  }

  @override
  Widget buildContent(LayoutModel layoutModel, BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          EdgeInsets titlePadding =
              EdgeInsets.only(top: 20, left: 30, right: 0);

          return Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 30, top: 30, right: 0),
              child: kIsWeb
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SizedBox(height: 10,width: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: BackButtonHeading(),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await Printing.layoutPdf(
                                      onLayout: (PdfPageFormat format) =>
                                      snapshot.data);
                                },
                                child: Text("Print"))
                          ],
                        ),

                        Container(
                          child: Text(
                            this.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          padding: titlePadding,
                        ),
                        PDFContentView(
                          pdfData: snapshot.data,
                        )
                      ],
                    )
                  : ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: BackButtonHeading(),
                        ),
                        Container(
                          child: Text(
                            this.title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          padding: titlePadding,
                        ),
                        PDFContentView(
                          pdfData: snapshot.data,
                        )
                      ],
                    ),
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
