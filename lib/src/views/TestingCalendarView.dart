import 'dart:collection';

import 'package:client_portal_app/src/models/EventEntryModel.dart';
import 'package:client_portal_app/src/models/LayoutModel.dart';
import 'package:client_portal_app/src/utils/UtilTest.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String _currentDate;
  Map<DateTime, List<EventEntryModel>> _events;

  @override
  void initState() {
    super.initState();
    _events = widget.events;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      // backgroundColor: Colors.pink,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color(0xffCECDCF),
              height: screenHeight * 0.6,
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

                /// Use `CalendarStyle` to customize the UI
                calendarStyle: CalendarStyle(
                    defaultTextStyle:
                        TextStyle(color: Colors.black, fontSize: 17),
                    outsideTextStyle:
                        TextStyle(color: Colors.blueGrey, fontSize: 17),
                    weekendTextStyle: TextStyle(
                      color: Color.fromRGBO(0, 100, 168, 1),
                      fontSize: 17,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    markerMargin: EdgeInsets.only(top: 8, left: 2),
                    markersAlignment: Alignment.bottomCenter,
                    cellMargin: EdgeInsets.all(10),
                    markerDecoration: BoxDecoration(
                        color: Color.fromRGBO(0, 100, 168, 1),
                        shape: BoxShape.circle),

                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: true,
                    todayTextStyle: TextStyle(color: Colors.black),
                    selectedTextStyle: TextStyle(color: Colors.black)),

                ///Heading view
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(0, 100, 168, 1)),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    )),
                daysOfWeekStyle: DaysOfWeekStyle(
                    dowTextFormatter: (date, locale) =>
                        DateFormat.E(locale).format(date)[0],
                    weekdayStyle: TextStyle(
                      color: Color.fromRGBO(0, 100, 168, 1),
                    ),
                    weekendStyle: TextStyle(
                      color: Color.fromRGBO(0, 100, 168, 1),
                    )),
                daysOfWeekHeight: screenHeight * 0.08,
                rowHeight: screenHeight * 0.07,
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Selected Date
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.03),
              child: Text(
                "${DateFormat.LLLL().format(_selectedDay) + DateFormat(' dd, yyyy').format(_selectedDay)}",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            /// List of Events

            ValueListenableBuilder<List<EventEntryModel>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 100, 168, 1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListTile(
                        onTap: () => print('..................${value[index]}'),
                        title: value[index].title.isNotEmpty
                            ? Text(
                                '${value[index].title}',
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                'There is no event on this date',
                                style: TextStyle(color: Colors.black),
                              ),
                      ),
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
