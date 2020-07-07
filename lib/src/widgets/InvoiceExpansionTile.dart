import 'package:client_portal_app/src/models/InvoiceModel.dart';
import 'package:flutter/material.dart';

class InvoiceExpansionTile extends StatelessWidget {
  const InvoiceExpansionTile(
      {Key key, @required this.invoiceModel, this.expanded = false})
      : super(key: key);
  final InvoiceModel invoiceModel;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.only(top: 0, bottom: 0),
      children: [],
      initiallyExpanded: expanded,
      title: Row(
        children: [
          Text(
            invoiceModel.number,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(invoiceModel.dateString),
          ),
          SizedBox(width: 15),
          Chip(label: Text(invoiceModel.status)),
          SizedBox(width: 15),
          Text(invoiceModel.amountString),
        ],
      ),
    );
  }
}
