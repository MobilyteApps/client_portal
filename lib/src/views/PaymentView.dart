import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/controllers/AppController.dart';
import 'package:client_portal_app/src/controllers/PaymentsController.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/TextHeading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({Key key, this.layoutModel}) : super(key: key);

  final LayoutModel layoutModel;

  Widget _optionsListView(context) {
    TextStyle listViewTitleStyle = TextStyle(
      color: Color.fromRGBO(0, 0, 0, .7),
    );
    return ListView(
      children: ListTile.divideTiles(
        color: Colors.black,
        context: context,
        tiles: [
          ListTile(
            title: Text(
              'More',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, .54),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'View Payments',
              style: listViewTitleStyle,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pushNamed('/billing/payments');
            },
          ),
          ListTile(
            trailing: Icon(Icons.chevron_right),
            leading: Icon(Icons.description),
            title: Text(
              'View Invoices',
              style: listViewTitleStyle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/billing/invoices');
            },
          ),
        ],
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 50, left: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5, bottom: 30),
            child: TextHeading(
              text: 'Billing and Payments',
            ),
          ),
          Card(
            color: Brand.primary,
            elevation: 1,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'No payment is due',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, .87),
                    ),
                  ),
                  Text(
                    "\$0.00",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, .87),
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(
                    height: 58,
                  ),
                  InkWell(
                    child: Text(
                      'Make a Payment',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, .87),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    onTap: () {
                      print('make a payment clicked');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _optionsListView(context),
          ),
        ],
      ),
    );
  }
}
