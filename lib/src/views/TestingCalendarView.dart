import 'dart:collection';

import 'package:client_portal_app/src/Brand.dart';
import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/models/RightDrawerModel.dart';
import 'package:client_portal_app/src/transitions/SlideLeftRoute.dart';
import 'package:client_portal_app/src/utils/DateExtension.dart';
import 'package:client_portal_app/src/utils/UtilTest.dart';
import 'package:client_portal_app/src/widgets/BackButtonHeading.dart';
import 'package:client_portal_app/src/widgets/EventEntryDetailPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

class TestingCalendarView extends StatefulWidget {
  final LayoutModel layoutModel;
  final SplayTreeMap<DateTime, List<EventEntryModel>> events;

  const TestingCalendarView({Key key, this.layoutModel, this.events})
      : super(key: key);

  @override
  _TestingCalendarViewState createState() => _TestingCalendarViewState();
}

class _TestingCalendarViewState extends State<TestingCalendarView> {
  double size;
  ValueNotifier<List<EventEntryModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;
  String _currentMonth;
  DateTime now = DateTime.now();
  Map<DateTime, List<EventEntryModel>> _events;

  @override
  void initState() {
    super.initState();
    _events = widget.events;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    _currentMonth = DateFormat('MMMM y').format(_focusedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<EventEntryModel> _getEventsForDay(DateTime day) {
    // Implementation example
    var date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  List<EventEntryModel> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  void _openEventDetailRight(EventEntryModel eventEntryModel) {
    Scaffold.of(context).openEndDrawer();
    ScopedModel.of<RightDrawerModel>(context).setContent(
      EventEntryDetailPanel(
        eventEntryModel: eventEntryModel,
      ),
    );
  }

  Color _backgroundColor() {
    return MediaQuery.of(context).size.width < 1024
        ? Colors.black12
        : Colors.white;
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

  Widget _customHeader() {
    var _padding = EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 5);
    if (MediaQuery.of(context).size.width >= 1024) {
      _padding = EdgeInsets.only(top: 5, bottom: 15, left: 40, right: 25);
    }
    return Container(
      padding: _padding,
      color: MediaQuery.of(context).size.width >= 1024
          ? Colors.white
          : Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _currentMonth != null
                ? Text(
                    _currentMonth,
                    style: TextStyle(
                      color: _backgroundColor() == Colors.black12
                          ? Colors.black.withOpacity(.54)
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
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month - 1);
                  _currentMonth = DateFormat.yMMM().format(_focusedDay);
                });
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
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month + 1);
                  _currentMonth = DateFormat.yMMM().format(_focusedDay);
                });
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
    var lastDayOfPrevMonth = DateTime(_focusedDay.year, _focusedDay.month, 0);

    var firstDayOfNextMonth =
        DateTime(_focusedDay.year, _focusedDay.month + 1, 1);

    var newDate = direction == ScrollDirection.forward
        ? firstDayOfNextMonth
        : lastDayOfPrevMonth;

    if (DateTime.now().isSameMonthAs(newDate)) {
      newDate = DateTime.now();
    }

    // focusedDay.setSelectedDay(
    //   newDate,
    //   isProgrammatic: true,
    //   animate: true,
    //   runCallback: true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _backButton(),
            _customHeader(),
            Container(
              color: Color(0xffFFFFFF),
              height: screenHeight * 0.55,
              width: screenWidth,

              /// Table calendar
              child: TableCalendar<EventEntryModel>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.sunday,

                calendarBuilders: CalendarBuilders(
                  singleMarkerBuilder: (context, datetime, event) {
                    Color eventColor = Color(event.backgroundColor);
                    return Padding(
                      padding:
                          EdgeInsets.only(top: screenHeight * 0.006, left: 2),
                      child: Container(
                        width: MediaQuery.of(context).size.width >= 1024
                            ? 8
                            : screenWidth * 0.02,
                        height: MediaQuery.of(context).size.width >= 1024
                            ? 8
                            : screenHeight * 0.02,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eventColor,
                        ),
                      ),
                    );
                  },
                ),

                /// Use `CalendarStyle` to customize the UI
                calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                        color: Colors.black, fontSize: screenHeight * 0.02),
                    outsideTextStyle: TextStyle(
                        color: Colors.blueGrey, fontSize: screenHeight * 0.02),
                    weekendTextStyle: TextStyle(
                      color: Color.fromRGBO(0, 100, 168, 1),
                      fontSize: screenHeight * 0.02,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    markersAlignment: Alignment.bottomCenter,
                    cellMargin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.015,
                        vertical: screenHeight * 0.015),
                    markerDecoration: BoxDecoration(
                        color: Color.fromRGBO(0, 100, 168, 1),
                        shape: BoxShape.circle),
                    outsideDaysVisible: true,
                    todayTextStyle: TextStyle(
                        color: Colors.black, fontSize: screenHeight * 0.02),
                    selectedTextStyle: TextStyle(color: Colors.black)),

                ///Heading view
                headerVisible: false,

                daysOfWeekStyle: DaysOfWeekStyle(
                    dowTextFormatter: (date, locale) =>
                        DateFormat.E(locale).format(date)[0],
                    weekdayStyle: TextStyle(
                        color: Color.fromRGBO(0, 100, 168, 1),
                        fontSize: screenHeight * 0.02),
                    weekendStyle: TextStyle(
                        color: Color.fromRGBO(0, 100, 168, 1),
                        fontSize: screenHeight * 0.02)),
                daysOfWeekHeight: screenHeight * 0.08,
                rowHeight: screenHeight * 0.07,
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            //SizedBox(height: screenHeight * 0.1),
            // Selected Date
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.03),
              child: DateTime(now.year, now.month, now.day) ==
                      DateTime(
                          _focusedDay.year, _focusedDay.month, _focusedDay.day)
                  ? Text(
                      "Today",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  : Text(
                      "${DateFormat.LLLL().format(_selectedDay) + DateFormat(' dd, yyyy').format(_selectedDay)}",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
            ),
            SizedBox(height: screenHeight * 0.02),

            /// List of Events

            ValueListenableBuilder<List<EventEntryModel>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return value.isEmpty
                    ? Center(
                        child: Text(
                          'No activities scheduled for this day',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(value[index].backgroundColor),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ListTile(
                                onTap: () {
                                  if (MediaQuery.of(context).size.width >=
                                      1024) {
                                    _openEventDetailRight(value[index]);
                                  } else {
                                    Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        settings: RouteSettings(),
                                        page: Material(
                                          child: EventEntryDetailPanel(
                                            eventEntryModel: value[index],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${value[index].title}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${value[index].trailing}',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
