import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/InvoiceModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:client_portal_app/src/widgets/SubHeading.dart';
import 'package:flutter/material.dart';

class InvoicesView extends StatelessWidget {
  InvoicesView({Key key}) : super(key: key);
  final Api api = Api(baseUrl: Config.apiBaseUrl);

  Widget _backButton(context) {
    if (MediaQuery.of(context).size.width >= 1024) {
      return Padding(
        padding: EdgeInsets.only(left: 0, top: 30, bottom: 15),
        child: BackButtonHeading(),
      );
    }

    return SizedBox();
  }

  Future<List<InvoiceModel>> _invoicesFuture() async {
    var response = await api.getInvoices();
    List _list = json.decode(response.body);
    return _list.map((e) => InvoiceModel.fromMap(e)).toList();
  }

  Widget _invoiceTile(InvoiceModel invoiceModel) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Colors.black.withOpacity(.12)))),
      child: Row(
        children: [
          Expanded(
            child: Text(
              invoiceModel.number,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(invoiceModel.dateString),
          ),
          SizedBox(width: 15),
          Text(invoiceModel.amountString),
          SizedBox(width: 15),
          /*Chip(
            label: Text(invoiceModel.status, style: TextStyle(fontSize: 12)),
            labelPadding: EdgeInsets.only(left: 5, right: 5),
          ),*/
        ],
      ),
    );
  }

  Widget _invoicesList() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<List<InvoiceModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            children: snapshot.data.map((e) => _invoiceTile(e)).toList(),
          );
        }
        return SizedBox();
      },
      future: _invoicesFuture(),
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets _containerPadding = EdgeInsets.only(left: 60, right: 60);
    if (MediaQuery.of(context).size.width < 1024) {
      _containerPadding = EdgeInsets.only(left: 20, right: 20, top: 35);
    }

    return Container(
      padding: _containerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _backButton(context),
          SubHeading(
            text: 'Invoices',
          ),
          SizedBox(height: 30),
          Expanded(
            child: _invoicesList(),
          )
        ],
      ),
    );
  }
}
