import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:flutter/material.dart';

class EventEntry extends StatelessWidget {
  const EventEntry({
    Key key,
    @required this.onTap,
    @required this.model,
  }) : super(key: key);

  final EventEntryModel model;
  final void Function(EventEntry) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 60),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Color(model.backgroundColor),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: () {
          onTap(this);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              model.title,
              style: TextStyle(
                  color: Color(model.textColor),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            model.trailing != null
                ? Text(
                    model.trailing,
                    style: TextStyle(
                      color: Color(model.textColor).withOpacity(.7),
                      fontSize: 14,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
