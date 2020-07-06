import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';

class PaymentModel {
  final String id;
  final String invoiceNumber;
  final String status;
  final DateTime dueDate;
  final DateTime paidDate;
  final double amount;
  final String method;
  final String notes;

  PaymentModel({
    this.id,
    this.invoiceNumber,
    this.status,
    this.dueDate,
    this.paidDate,
    this.amount,
    this.method,
    this.notes,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'],
      invoiceNumber: map['invoiceNumber'],
      status: map['status'] != null ? map['status'] : 'N/A',
      dueDate:
          map['dueDate'] != null ? DateTime.tryParse(map['dueDate']) : null,
      paidDate:
          map['paidDate'] != null ? DateTime.tryParse(map['paidDate']) : null,
      amount: map['amount'] != null ? map['amount'] : 0.00,
      method: map['method'] != null ? map['method'] : 'N/A',
      notes: map['notes'] != null ? map['notes'] : '',
    );
  }

  String get dueDateString {
    var fmt = DateFormat('MMMM d, y');
    return fmt.format(this.dueDate);
  }

  String get amountDueString {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: this.amount);
    return fmf.output.symbolOnLeft;
  }
}
