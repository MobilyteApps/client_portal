import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/widgets/EventEntry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key key, this.layoutModel, this.events})
      : super(key: key);
  final LayoutModel layoutModel;
  final List<EventEntryModel> events;
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarController _calendarController;
  Map<DateTime, List<EventEntryModel>> _events;
  List<EventEntryModel> _eventListModels = [];
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    String today = DateFormat.yMd().format(DateTime.now());

    widget.events.forEach((event) {
      DateTime ymd = DateTime.parse(event.ymd());
      if (_events.containsKey(ymd) == false) {
        _events[ymd] = [];
      }
      _events[ymd].add(event);

      if (DateFormat.yMd().format(ymd) == today) {
        _eventListModels.add(event);
      }
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          child: Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        _calendar(),
        Expanded(
          child: _eventList(),
        ),
      ],
    );
  }

  Widget _calendar() {
    return TableCalendar(
      onDaySelected: (dateTime, events) {
        setState(() {
          if (events.length > 0) {
            _eventListModels = events;
          } else {
            _eventListModels = [];
          }
        });
      },
      initialSelectedDay: DateTime.parse('2020-03-05'),
      headerVisible: false,
      builders: CalendarBuilders(
        dowWeekdayBuilder: (context, s) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              s,
              style: TextStyle(
                color: Color.fromRGBO(0, 100, 168, .5),
              ),
            ),
          );
        },
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextBuilder: (DateTime dateTime, locale) {
          return DateFormat.E(locale).format(dateTime).substring(0, 1);
        },
        weekdayStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
        weekendStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
      ),
      calendarStyle: CalendarStyle(
        weekendStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
        weekdayStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
        selectedColor: Brand.primary,
        selectedStyle: TextStyle(
          color: Colors.white,
        ),
        todayColor: Color.fromRGBO(0, 0, 0, .2),
        todayStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
      ),
      rowHeight: 45,
      events: _events,
      calendarController: _calendarController,
    );
  }

  Widget _eventList() {
    List<EventEntry> entries = [];
    if (_eventListModels != null) {
      _eventListModels.forEach((element) {
        entries.add(
          EventEntry(
            model: element,
          ),
        );
      });
    }

    return ListView(
      padding: EdgeInsets.only(left: 40, right: 40, top: 10),
      shrinkWrap: true,
      children: entries,
    );
  }

  @override
  Widget build(BuildContext context) {
    return content();
  }
}
