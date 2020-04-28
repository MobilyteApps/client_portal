import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:client_portal_app/src/widgets/EventEntry.dart';
import 'package:client_portal_app/src/widgets/EventEntryDetailPanel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
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
  DateTime _initialSelectedDay = DateTime.now();
  String _currentMonth;
  @override
  void initState() {
    super.initState();

    _currentMonth = DateFormat('MMMM y').format(_initialSelectedDay);

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

  Widget _backButton() {
    return BackButtonHeading();
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: _backButton(),
          padding: EdgeInsets.only(top: 25, left: 40, bottom: 25),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 55,
            right: 35,
          ),
        ),
        Padding(
          child: _calendar(),
          padding: EdgeInsets.only(left: 15),
        ),
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
          _currentMonth = DateFormat('MMMM y').format(dateTime);
        });
      },
      initialSelectedDay: _initialSelectedDay,
      headerVisible: true,
      availableCalendarFormats: {
        CalendarFormat.month: 'Month',
      },
      builders: CalendarBuilders(
        singleMarkerBuilder: (context, datetime, event) {
          Color color = Color(event.backgroundColor);
          return Container(
            width: 7,
            height: 7,
            margin: EdgeInsets.only(left: 1, right: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          );
        },
        selectedDayBuilder: (context, dateTime, list) {
          return Container(
            margin: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, .2),
              shape: BoxShape.circle,
            ),
            child: Text(
              dateTime.day.toString(),
            ),
          );
        },
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
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        headerMargin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      ),
      calendarStyle: CalendarStyle(
        outsideStyle: TextStyle(color: Color.fromRGBO(0, 100, 168, .5)),
        outsideWeekendStyle: TextStyle(color: Color.fromRGBO(0, 100, 168, .5)),
        markersPositionBottom: 0,
        weekendStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
        weekdayStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
        selectedColor: Color.fromRGBO(0, 0, 0, .2),
        selectedStyle: TextStyle(
          color: Colors.white,
        ),
        todayColor: Colors.white,
        todayStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      rowHeight: 55,
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
            onTap: (EventEntry eventEntry) {
              Scaffold.of(context).openEndDrawer();
              ScopedModel.of<RightDrawerModel>(context).setContent(
                EventEntryDetailPanel(
                  eventEntryModel: element,
                ),
              );
            },
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
