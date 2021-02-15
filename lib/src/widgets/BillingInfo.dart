import 'package:client_portal_app/src/models/BillingInfoModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BillingInfo extends StatelessWidget {
  const BillingInfo({Key key, this.billingInfoModel}) : super(key: key);

  final BillingInfoModel billingInfoModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _billingRow(
          'Original Contract Amount',
          BillingInfoModel.money(billingInfoModel.originalContractAmount),
        ),
        _billingRow(
          'Change Orders Contracted',
          BillingInfoModel.money(billingInfoModel.changeOrderAmount),
        ),
        _divider(),
        _billingRow(
          'Total Contracted Amount',
          BillingInfoModel.money(billingInfoModel.totalContractAmount),
        ),
        _spacer(),
        _billingRow(
          'Total Approved Financing (if applicable)',
          BillingInfoModel.money(billingInfoModel.financedAmount),
          true,
        ),
        SizedBox(
          height: 10,
        ),
        _billingRow(
          'Finance Applied to Project',
          BillingInfoModel.money(billingInfoModel.financedAmountApplied),
        ),
        _spacer(),
        _billingRow(
          'Non-Financed Payments Applied to Project',
          BillingInfoModel.money(billingInfoModel.paymentsReceivedAmount),
        ),
        _divider(),
        _billingRow(
          'Remaining Unpaid Contracted Amount',
          BillingInfoModel.money(billingInfoModel.remainingUnpaidAmount),
        ),
        _spacer(),
        _billingRow(
          'Payments Past Due',
          BillingInfoModel.money(billingInfoModel.paymentsPastDueAmount),
        ),
        _billingRow(
          'Days Past Due',
          billingInfoModel.paymentsPastDueDays > 0
              ? billingInfoModel.paymentsPastDueDays.toString()
              : '-',
        ),
        _spacer(),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'For a complete statement of payments, please email',
                  style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: ' billings@callmosby.com',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      var url = 'mailto:billings@callmosby.com';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Divider(
        color: Colors.black,
        thickness: 1,
        height: 1,
      ),
    );
  }

  Widget _spacer() {
    return SizedBox(
      height: 25,
    );
  }

  Widget _billingRow(String label, String value, [bool offset = false]) {
    List<Widget> children = [];

    children.add(_label(label));
    children.add(Container(
      child: _value(value),
      padding: EdgeInsets.only(left: 10),
    ));

    if (offset) {
      children.add(SizedBox(
        width: 100,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  Widget _label(String text) {
    return Flexible(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _value(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }
}
