import 'package:client_portal_app/src/models/InvoiceModel.dart';
import 'package:client_portal_app/src/widgets/InvoiceDetail.dart';
import 'package:client_portal_app/src/widgets/InvoiceRow.dart';
import 'package:flutter/material.dart';

class InvoiceExpansionTile extends StatelessWidget {
  const InvoiceExpansionTile(
      {Key key, @required this.title, this.detail, this.expanded = false})
      : super(key: key);
  final InvoiceRow title;
  final bool expanded;
  final InvoiceDetail detail;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.only(top: 0, bottom: 0),
      children: [
        detail,
      ],
      initiallyExpanded: expanded,
      title: title,
      expandedCrossAxisAlignment: CrossAxisAlignment.end,
      trailing: SizedBox(),
    );
  }
}
