import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/PaymentModel.dart';
import 'package:client_portal_app/src/transitions/SlideLeftRoute.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/views/InvoicesView.dart';
import 'package:client_portal_app/src/views/PaymentsView.dart';
import 'package:client_portal_app/src/widgets/PanelBackButton.dart';
import 'package:client_portal_app/src/widgets/PanelScaffold.dart';
import 'package:client_portal_app/src/widgets/TextHeading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BillingAndPaymentsView extends StatelessWidget {
  BillingAndPaymentsView({Key key, this.layoutModel}) : super(key: key);

  final LayoutModel layoutModel;

  final Api api = Api(baseUrl: Config.apiBaseUrl);

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
              if (MediaQuery.of(context).size.width < 1024) {
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    settings: RouteSettings(
                      arguments: {},
                    ),
                    page: PanelScaffold(
                      centerTitle: false,
                      leading: PanelBackButton(),
                      title: 'Billing and Payments',
                      body: PaymentsView(),
                    ),
                  ),
                );
              } else {
                Navigator.of(context).pushNamed('/billing/payments');
              }
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
              if (MediaQuery.of(context).size.width < 1024) {
                Navigator.push(
                  context,
                  SlideLeftRoute(
                    settings: RouteSettings(
                      arguments: {},
                    ),
                    page: PanelScaffold(
                      centerTitle: false,
                      leading: PanelBackButton(),
                      title: 'Billing and Payments',
                      body: InvoicesView(),
                    ),
                  ),
                );
              } else {
                Navigator.of(context).pushNamed('/billing/invoices');
              }
            },
          ),
        ],
      ).toList(),
    );
  }

  Future<PaymentModel> _nextPaymentFuture() async {
    var response = await api.getNextPaymentDue();
    return PaymentModel.fromMap(json.decode(response.body));
  }

  Widget _nextPaymentCard() {
    return FutureBuilder(
      future: _nextPaymentFuture(),
      builder: (context, AsyncSnapshot<PaymentModel> snapshot) {
        String _title = '';
        String _amount = '';
        bool makePayment = true;

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            _title = 'Payment due by ' + snapshot.data.dueDateString;
            _amount = snapshot.data.amountDueString;
          } else {
            _title = 'No payment is due';
            _amount = '\$0.00';
            makePayment = false;
          }
        }

        return Card(
          color: Brand.primary,
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _title,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, .87),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  _amount,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, .87),
                    fontSize: 36,
                  ),
                ),
                SizedBox(
                  height: 58,
                ),
                makePayment
                    ? InkWell(
                        child: Text(
                          'Make a Payment',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, .87),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        onTap: () {
                          String projectId = layoutModel.project.id;
                          String url =
                              'http://pay.mosbybuildingarts.com/?project_id=$projectId';

                          url = 'https://anvilinsights.com';

                          print(url);

                          canLaunch(url).then((value) {
                            launch(url);
                          });
                          print('make a payment clicked');
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.only(top: 50, left: 45);
    if (MediaQuery.of(context).size.width < 1024) {
      padding = EdgeInsets.only(top: 35, left: 15, right: 15);
    }
    return Container(
      alignment: Alignment.topLeft,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5, bottom: 30),
            child: TextHeading(
              text: 'Billing and Payments',
            ),
          ),
          _nextPaymentCard(),
          Expanded(
            child: _optionsListView(context),
          ),
        ],
      ),
    );
  }
}
