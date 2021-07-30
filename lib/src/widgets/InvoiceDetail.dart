import 'package:client_portal_app/src/models/InvoiceModel.dart';
import 'package:flutter/material.dart';

class InvoiceDetail extends StatelessWidget {
  const InvoiceDetail({Key key, this.model, this.padding}) : super(key: key);

  final InvoiceModel model;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: DataTable(
        showBottomBorder: false,
        headingRowHeight: 0,
        columns: [
          DataColumn(label: Text("")),
          DataColumn(label: Text("")),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Invoice Amount')),
            DataCell(Text(model?.amountString??""))
          ]),
          DataRow(cells: [
            DataCell(Text('Total Payments')),
            DataCell(Text('- ${model?.totalPaymentAmountString??""}'))
          ]),
          DataRow(cells: [
            DataCell(Text('Balance')),
            DataCell(Text(model?.balanceString))
          ]),
        ],
      ),
    );
  }
}
