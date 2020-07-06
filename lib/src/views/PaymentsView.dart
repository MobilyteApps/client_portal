import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/models/PaymentModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:client_portal_app/src/widgets/PaymentExpansionTile.dart';
import 'package:client_portal_app/src/widgets/SubHeading.dart';
import 'package:client_portal_app/src/widgets/TextHeading.dart';
import 'package:flutter/material.dart';

class PaymentsView extends StatelessWidget {
  PaymentsView({Key key}) : super(key: key);

  final Api api = Api(baseUrl: Config.apiBaseUrl);

  Widget _backButton(context) {
    if (MediaQuery.of(context).size.width < 1024) {
      return SizedBox();
    }
    return BackButtonHeading();
  }

  Future<PaymentModel> _lastPaymentFuture() async {
    var response = await api.getLastPayment();
    return PaymentModel.fromMap(json.decode(response.body));
  }

  Widget _lastPayment() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<PaymentModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return PaymentExpansionTile(
            paymentModel: snapshot.data,
          );
        }

        return SizedBox();
      },
      future: _lastPaymentFuture(),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.black.withOpacity(.12),
      margin: EdgeInsets.only(top: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets _containerPadding = EdgeInsets.only(top: 40, left: 40);
    if (MediaQuery.of(context).size.width < 1024) {
      _containerPadding = EdgeInsets.only(top: 35, left: 20, right: 20);
    }
    return Container(
      padding: _containerPadding,
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _backButton(context),
          TextHeading(
            text: 'Payments',
          ),
          SizedBox(
            height: 30,
          ),
          SubHeading(
            text: 'Last Payment',
          ),
          _divider(),
          _lastPayment(),
          SizedBox(
            height: 35,
          ),
          SubHeading(
            text: 'Previous Payments',
          ),
        ],
      ),
    );
  }
}
