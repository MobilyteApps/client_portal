import 'package:client_portal_app/src/models/PaymentModel.dart';
import 'package:flutter/material.dart';

class PaymentExpansionTile extends StatelessWidget {
  const PaymentExpansionTile({
    Key key,
    @required this.paymentModel,
    this.expanded = false,
  }) : super(key: key);
  final PaymentModel paymentModel;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    var boldText = TextStyle(fontWeight: FontWeight.bold);
    return ExpansionTile(
      initiallyExpanded: expanded,
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
            Text(
              'Payment status: ',
              style: boldText,
            ),
            Text(paymentModel.status),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Payment method: ',
              style: boldText,
            ),
            Text(paymentModel.method),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              'Payment notes: ',
              style: boldText,
            ),
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
