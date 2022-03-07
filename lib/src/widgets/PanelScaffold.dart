import 'dart:io';

import 'package:client_portal_app/src/widgets/PanelCloseButton.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PanelScaffold extends Scaffold {
  final Widget body;

  final Widget leading;

  PanelScaffold({
    Key key,
    List<Widget> actions,
    String title,
    this.body,
    this.leading,
    needPrintAction = false,
    var document,
    bool centerTitle = true,
  }) : super(
          key: key,
          body: body,
          appBar: AppBar(
            centerTitle: centerTitle,
            elevation: 0,
            title: Text(title),
            actions: [
              if (needPrintAction && document != null)
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
                        onLayout: (PdfPageFormat format) async => document);
                    // document.buffer.asUint8List());
                  },
                ),
            ],
            leading: leading == null ? PanelCloseButton() : leading,
          ),
        );
}
