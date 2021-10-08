import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

class InvoiceModel {
  String number;
  DateTime date;
  String status;
  double amount;
  double balance;

  InvoiceModel({
    this.number,
    this.date,
    this.status,
    this.amount,
    this.balance,
  });

  factory InvoiceModel.fromMap(map) {
    return InvoiceModel(
      number: map['number'] != null ? map['number'] : '',
      date: map['date'] != null ? DateTime.tryParse(map['date']) : null,
      status: map['status'] != null ? map['status'] : '',
      amount: map['amount'] != null
          ? double.tryParse(map['amount'].toString())
          : 0.00,
      balance: map['balance'] != null
          ? double.tryParse(map['balance'].toString())
          : 0.00,
    );
  }

  String get balanceString {
    CurrencyTextInputFormatter _formatter= CurrencyTextInputFormatter(symbol: '\$');
    return  _formatter.format(amount.toString());
  }

  String get amountString {
    CurrencyTextInputFormatter _formatter= CurrencyTextInputFormatter(symbol: '\$');
    return  _formatter.format(amount.toString());
  }

  String get dateString {
    var fmt = DateFormat('MMMM d, y');
    return fmt.format(this.date);
  }

  String get totalPaymentAmountString {
    var amount = this.amount - this.balance;
    CurrencyTextInputFormatter _formatter= CurrencyTextInputFormatter(symbol: '\$');
    return  _formatter.format(amount.toString());
  }
}
