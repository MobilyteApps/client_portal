import 'dart:collection';

import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:client_portal_app/src/widgets/EventEntry.dart';
import 'package:client_portal_app/src/widgets/EventEntryDetailPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:client_portal_app/src/utils/DateExtension.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key key, this.layoutModel, this.events})
      : super(key: key);
  final LayoutModel layoutModel;
  final SplayTreeMap<DateTime, List<EventEntryModel>> events;
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarController _calendarController;
  Map<DateTime, List<EventEntryModel>> _events;
  List<EventEntryModel> _eventListModels = [];
  DateTime _initialSelectedDay = DateTime.now();
  String _currentMonth;
  String _currentDate;
  @override
  void initState() {
    super.initState();

    _currentMonth = DateFormat('MMMM y').format(_initialSelectedDay);

    if (_initialSelectedDay.isToday) {
      _currentDate = 'Today';
    } else {
      _currentDate = DateFormat('MMMM, y').format(_initialSelectedDay);
    }
    _calendarController = CalendarController();

    _events = {};
    DateTime today = DateTime.now().copyWithHMS(0, 0, 0);

    _events = widget.events;

    if (_events.containsKey(today)) {
      _eventListModels = _events[today];
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget _backButton() {
    if (MediaQuery.of(context).size.width < 1024) {
      return SizedBox();
    }
    return Padding(
      child: BackButtonHeading(),
      padding: EdgeInsets.only(top: 25, left: 40, bottom: 25),
    );
  }

  Color _backgroundColor() {
    return MediaQuery.of(context).size.width < 1024
        ? Colors.black12
        : Colors.white;
  }

  Widget _customHeader() {
    var _padding = EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 5);
    if (MediaQuery.of(context).size.width >= 1024) {
      _padding = EdgeInsets.only(top: 5, bottom: 15, left: 40, right: 25);
    }
    return Container(
      padding: _padding,
      color: MediaQuery.of(context).size.width >= 1024
          ? Colors.white
          : Brand.primary,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _currentMonth != null
                ? Text(
                    _currentMonth,
                    style: TextStyle(
                      color: _backgroundColor() == Brand.primary
                          ? Colors.white
                          : Colors.black.withOpacity(.54),
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          SizedBox(
            child: IconButton(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onPressed: () {
                _navigateCalendar(ScrollDirection.reverse);
              },
              icon: Icon(
                Icons.chevron_left,
                color: _backgroundColor() == Brand.primary
                    ? Colors.white
                    : Colors.black.withOpacity(.54),
              ),
            ),
          ),
          SizedBox(
            child: IconButton(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onPressed: () {
                _navigateCalendar(ScrollDirection.forward);
              },
              icon: Icon(
                Icons.chevron_right,
                color: _backgroundColor() == Brand.primary
                    ? Colors.white
                    : Colors.black.withOpacity(.54),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _navigateCalendar(ScrollDirection direction) {
    var lastDayOfPrevMonth = DateTime(_calendarController.selectedDay.year,
        _calendarController.selectedDay.month, 0);

    var firstDayOfNextMonth = DateTime(_calendarController.selectedDay.year,
        _calendarController.selectedDay.month + 1, 1);

    var newDate = direction == ScrollDirection.forward
        ? firstDayOfNextMonth
        : lastDayOfPrevMonth;

    if (DateTime.now().isSameMonthAs(newDate)) {
      newDate = DateTime.now();
    }

    _calendarController.setSelectedDay(
      newDate,
      isProgrammatic: true,
      animate: true,
      runCallback: true,
    );
  }

  Widget _eventListHeader() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40, right: 40),
      child: Text(
        _currentDate,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black.withOpacity(.54),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _backButton(),
        _customHeader(),
        Container(
          color: _backgroundColor(),
          child: _calendar(),
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width >= 1024 ? 2 : 0,
            top: MediaQuery.of(context).size.width < 1024 ? 15 : 0,
          ),
        ),
        _eventListHeader(),
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
          _currentDate = DateFormat('MMMM d, y').format(dateTime);
        });
      },
      initialSelectedDay: _initialSelectedDay,
      headerVisible: false,
      availableCalendarFormats: {
        CalendarFormat.month: 'Month',
      },
      builders: CalendarBuilders(
        todayDayBuilder: (context, dateTime, event) {
          return Container(
            margin: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              dateTime.day.toString(),
            ),
          );
        },
        singleMarkerBuilder: (context, datetime, event) {
          Color eventColor = Color(event.backgroundColor);
          return Container(
            width: 7,
            height: 7,
            margin: EdgeInsets.only(left: 1, right: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: eventColor,
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
          color: _backgroundColor() == Brand.primary
              ? Colors.white
              : Brand.primary,
        ),
        weekendStyle: TextStyle(
          color: Color.fromRGBO(0, 100, 168, 1),
        ),
      ),
      headerStyle: HeaderStyle(
        leftChevronMargin: EdgeInsets.all(0),
        leftChevronPadding: EdgeInsets.all(0),
        centerHeaderTitle: MediaQuery.of(context).size.width >= 1024,
        headerMargin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        titleTextStyle: TextStyle(
          fontSize: 18,
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideStyle: TextStyle(
          color: _backgroundColor() == Brand.primary
              ? Colors.white.withOpacity(.5)
              : Brand.primary.withOpacity(.5),
        ),
        outsideWeekendStyle: TextStyle(
          color: _backgroundColor() == Brand.primary
              ? Colors.white.withOpacity(.5)
              : Brand.primary.withOpacity(.5),
        ),
        markersPositionBottom: 0,
        weekendStyle: TextStyle(
          color: _backgroundColor() == Brand.primary
              ? Colors.white
              : Brand.primary,
        ),
        weekdayStyle: TextStyle(
            color: _backgroundColor() == Brand.primary
                ? Colors.white
                : Brand.primary),
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

    if (entries.length == 0) {
      return Container(
        padding: EdgeInsets.only(left: 40, right: 40, top: 10),
        child: Text('No activities scheduled for this day.'),
      );
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
