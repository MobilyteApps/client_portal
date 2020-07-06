import 'package:client_portal_app/src/models/PaymentModel.dart';
import 'package:flutter/material.dart';

class PaymentExpansionTile extends StatelessWidget {
  const PaymentExpansionTile({Key key, @required this.paymentModel})
      : super(key: key);
  final PaymentModel paymentModel;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      tilePadding: EdgeInsets.only(top: 0, bottom: 0),
      title: Row(
        children: [
          Expanded(
            child: Text(paymentModel.dueDateString),
          ),
          Text(paymentModel.amountDueString),
        ],
      ),
      children: [
        Row(
          children: [
            Text('Payment status: '),
            Text(paymentModel.status),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text('Payment method: '),
            Text(paymentModel.method),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text('Payment notes: '),
            Text(paymentModel.notes),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
