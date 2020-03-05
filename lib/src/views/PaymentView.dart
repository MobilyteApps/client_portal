import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:flutter/cupertino.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({Key key, this.layoutModel}) : super(key: key);

  final LayoutModel layoutModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('payments for ' + layoutModel.project.title),
    );
  }
}
