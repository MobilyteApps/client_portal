import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:flutter/material.dart';

class EventEntryDetailPanel extends StatelessWidget {
  const EventEntryDetailPanel({Key key, @required this.eventEntryModel})
      : super(key: key);

  final EventEntryModel eventEntryModel;

  Widget header(context) {
    return Container(
      constraints: BoxConstraints(minHeight: 130),
      width: double.infinity,
      decoration: BoxDecoration(color: Color(eventEntryModel.backgroundColor)),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(eventEntryModel.textColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              child: Text(
                eventEntryModel.title,
                style: TextStyle(
                  color: Color(eventEntryModel.textColor),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            ),
          ],
        ),
      ),
    );
  }

  Color darkenColor(int color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(Color(color));
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  List<Widget> listViewItems() {
    List<Widget> _listViewItems = [];

    // add the date header
    _listViewItems.add(
      Container(
        color: darkenColor(eventEntryModel.backgroundColor),
        child: ListTile(
          leading: Icon(
            Icons.event,
            color: Colors.white,
          ),
          title: Text(
            eventEntryModel.date() == null ? '' : eventEntryModel.date(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    String time = eventEntryModel.time();
    if (time.length > 0 && eventEntryModel.allDay == false) {
      _listViewItems.add(
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text(eventEntryModel.time()),
        ),
      );
    }

    if (eventEntryModel.location.length != null &&
        eventEntryModel.location.length > 0) {
      _listViewItems.add(
        ListTile(
          leading: Icon(Icons.place),
          title: Text(eventEntryModel.location),
        ),
      );
    }

    if (eventEntryModel.description != null &&
        eventEntryModel.description.length > 0) {
      _listViewItems.add(
        ListTile(
          leading: Icon(Icons.format_list_bulleted),
          title: Text(eventEntryModel.description),
        ),
      );
    }

    return _listViewItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        header(context),
        Container(
          child: ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            children: listViewItems(),
          ),
        )
      ],
    );
  }
}
