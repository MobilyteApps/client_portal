import 'dart:convert';

import 'package:client_portal_app/src/Api.dart';
import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/BillingInfoModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/PaymentModel.dart';
import 'package:client_portal_app/src/utils/Config.dart';
import 'package:client_portal_app/src/widgets/BillingInfo.dart';
import 'package:client_portal_app/src/widgets/TextHeading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BillingAndPaymentsView extends StatelessWidget {
  BillingAndPaymentsView({Key key, this.layoutModel}) : super(key: key);

  final LayoutModel layoutModel;

  final Api api = Api(baseUrl: Config.apiBaseUrl);

  BillingInfoModel billingInfoModel;

  Future<BillingInfoModel> _billingInfoFuture() async {
    var response = await api.getBillingInfo();
    billingInfoModel = BillingInfoModel.fromMap(json.decode(response.body));
    return billingInfoModel;
  }

  Widget _billingInfo() {
    return FutureBuilder(
      future: _billingInfoFuture(),
      builder: (context, AsyncSnapshot<BillingInfoModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            padding: MediaQuery.of(context).size.width > 1024
                ? EdgeInsets.only(left: 50, bottom: 15, right: 5)
                : EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: BillingInfo(
              billingInfoModel: snapshot.data,
            ),
          );
        }
        return SizedBox();
      },
    );
  }

  Widget _nextPaymentCard(BuildContext context) {
    EdgeInsets padding = EdgeInsets.only(top: 0, left: 45);
    if (MediaQuery.of(context).size.width < 1024) {
      padding = EdgeInsets.only(top: 15, left: 15, right: 15);
    }
    return FutureBuilder(
      future: _billingInfoFuture(),
      builder: (context, AsyncSnapshot<BillingInfoModel> snapshot) {
        String _title = 'Current Balance Due';
        String _amount = '';
        bool makePayment = false;

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.isFinanced == false) {
            makePayment = true;
          }
          if (snapshot.data != null) {
            if (snapshot.data.nextPaymentDueDateString == null) {
              _amount = '\$ 0.00';
            } else {
              _amount = BillingInfoModel.money(snapshot.data.nextPaymentAmount);
            }
          } else {
            _title = 'Current Balance Due';
            _amount = '\$ 0.00';
            makePayment = false;
          }
        }

        return Container(
          padding: padding,
          child: Card(
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
                            String baseUrl = Config.paymentUrl;
                            String url = '$baseUrl/?project_id=$projectId';

                            canLaunch(url).then((value) {
                              launch(url);
                            });
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _heading(BuildContext context) {
    if (MediaQuery.of(context).size.width < 1024) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(left: 50, bottom: 30, top: 50),
      child: TextHeading(
        text: 'Billing and Payments',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _heading(context),
          _nextPaymentCard(context),
          SizedBox(
            height: 15,
          ),
          _billingInfo(),
        ],
      ),
    );
  }
}
