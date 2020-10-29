import 'package:client_portal_app/src/models/InvoiceModel.dart';
import 'package:flutter/material.dart';

class InvoiceRow extends StatelessWidget {
  const InvoiceRow({Key key, this.model, this.padding}) : super(key: key);

  final InvoiceModel model;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // invoice detail column
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.number,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              Chip(
                labelPadding: EdgeInsets.all(0),
                padding:
                    EdgeInsets.only(top: 0, right: 10, bottom: 0, left: 10),
                label: Text(
                  model.status,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          //amount column
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                model.dateString,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
