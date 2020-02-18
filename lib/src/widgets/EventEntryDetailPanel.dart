import 'package:client_portal_app/src/widgets/EventEntry.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EventEntryDetailPanel extends StatelessWidget {
  const EventEntryDetailPanel({Key key, @required this.eventEntry})
      : super(key: key);

  final EventEntry eventEntry;

  Widget header(context) {
    return Container(
      constraints: BoxConstraints(minHeight: 130),
      width: double.infinity,
      decoration: BoxDecoration(color: Color(eventEntry.backgroundColor)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(eventEntry.textColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Padding(
            child: Text(
              eventEntry.title,
              style: TextStyle(
                color: Color(eventEntry.textColor),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          ),
        ],
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
        color: darkenColor(eventEntry.backgroundColor),
        child: ListTile(
          leading: Icon(
            Icons.event,
            color: Colors.white,
          ),
          title: Text(
            eventEntry.date() == null ? '' : eventEntry.date(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    String time = eventEntry.time();
    if (time.length > 0) {
      _listViewItems.add(
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text(eventEntry.time()),
        ),
      );
    }

    if (eventEntry.location.length != null && eventEntry.location.length > 0) {
      _listViewItems.add(
        ListTile(
          leading: Icon(Icons.place),
          title: Text(eventEntry.location),
        ),
      );
    }

    if (eventEntry.description != null && eventEntry.description.length > 0) {
      _listViewItems.add(
        ListTile(
          leading: Icon(Icons.format_list_bulleted),
          title: Text(eventEntry.description),
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
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: listViewItems(),
          ),
        )
      ],
    );
  }
}
