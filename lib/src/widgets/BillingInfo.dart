import 'package:client_portal_app/src/models/BillingInfoModel.dart';
import 'package:flutter/material.dart';

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
          'Financed Funds (if applicable)',
          BillingInfoModel.money(billingInfoModel.financedAmount),
        ),
        _billingRow(
          'Finance Funds Applied to Project',
          BillingInfoModel.money(billingInfoModel.financedAmountApplied),
        ),
        _spacer(),
        _billingRow(
          'Payments Received To Date',
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
        Text(
            'For a complete statement of payments, please email billings@callmosby.com'),
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

  Widget _billingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _label(label),
        _value(value),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
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
