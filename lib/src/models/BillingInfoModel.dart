import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

class BillingInfoModel {
  double originalContractAmount = 0.00;
  double changeOrderAmount = 0.00;
  double financedAmount;
  double financedAmountApplied;
  double paymentsReceivedAmount;
  double paymentsPastDueAmount;
  int paymentsPastDueDays;
  double nextPaymentAmount;
  DateTime nextPaymentDueDate;

  BillingInfoModel({
    this.originalContractAmount,
    this.changeOrderAmount,
    this.financedAmount,
    this.financedAmountApplied,
    this.paymentsReceivedAmount,
    this.paymentsPastDueAmount,
    this.paymentsPastDueDays,
    this.nextPaymentAmount,
    this.nextPaymentDueDate,
  });

  factory BillingInfoModel.fromMap(map) {
    return new BillingInfoModel(
      originalContractAmount: map['originalContractAmount'] != null
          ? double.tryParse(map['originalContractAmount'].toString())
          : 0.00,
      changeOrderAmount: map['changeOrderAmount'] != null
          ? double.tryParse(map['changeOrderAmount'].toString())
          : 0.00,
      financedAmount: map['financedAmount'] != null
          ? double.tryParse(map['financedAmount'].toString())
          : 0.00,
      financedAmountApplied: map['financedAmountApplied'] != null
          ? double.tryParse(map['financedAmountApplied'].toString())
          : 0.00,
      paymentsReceivedAmount: map['paymentsReceivedAmount'] != null
          ? double.tryParse(map['paymentsReceivedAmount'].toString())
          : 0.00,
      paymentsPastDueAmount: map['paymentsPastDueAmount'] != null
          ? double.tryParse(map['paymentsPastDueAmount'].toString())
          : 0.00,
      paymentsPastDueDays: map['paymentsPastDueDays'] != null
          ? int.tryParse(map['paymentsPastDueDays'].toString())
          : 0.00,
      nextPaymentAmount: map['nextPaymentAmount'] != null
          ? double.tryParse(map['nextPaymentAmount'].toString())
          : 0.00,
      nextPaymentDueDate: map['nextPaymentDueDate'] != null
          ? DateTime.tryParse(map['nextPaymentDueDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalContractAmount': originalContractAmount,
      'changeOrderAmount': changeOrderAmount,
      'financedAmount': financedAmount,
      'financedAmountApplied': financedAmountApplied,
      'paymentsReceivedAmount': paymentsReceivedAmount,
      'paymentsPastDueAmount': paymentsPastDueAmount,
      'paymentsPastDueDays': paymentsPastDueDays,
      'nextPaymentAmount': nextPaymentAmount,
      'nextPaymentDueDate': nextPaymentDueDate,
    };
  }

  @override
  String toString() {
    return json.encode(toMap());
  }

  double get totalContractAmount {
    double totalAmount=this.changeOrderAmount + this.originalContractAmount;
    return double.parse(totalAmount.toStringAsFixed(2));
  }

  double get remainingUnpaidAmount {
    return this.totalContractAmount - this.paymentsReceivedAmount;
  }

  static money(double amount) {
    CurrencyTextInputFormatter _formatter= CurrencyTextInputFormatter(symbol: '\$' );
    
    if (amount == 0.00) {
      return _formatter.format(amount.toString()) + '          -';
    }

    return _formatter.format(amount.toStringAsFixed(2));
  }

  bool get isFinanced {
    return financedAmount != null && financedAmount > 0;
  }

  String get nextPaymentDueDateString {
    if (this.nextPaymentDueDate == null) {
      return null;
    }
    var fmt = DateFormat('MMMM d, y');
    return fmt.format(this.nextPaymentDueDate);
  }
}
