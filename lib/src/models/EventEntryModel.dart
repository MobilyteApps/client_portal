import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:client_portal_app/src/utils/DateExtension.dart';

class EventEntryModel {
  EventEntryModel({
    this.backgroundColor,
    this.textColor,
    this.title,
    this.trailing,
    this.startDateTime,
    this.endDateTime,
    this.location,
    this.description,
    this.isMultiDay,
    this.allDay,
  });

  int backgroundColor;
  int textColor;
  String title;
  String trailing;
  DateTime startDateTime;
  DateTime endDateTime;
  String location;
  String description;
  bool isMultiDay;
  bool allDay;

  EventEntryModel.fromJson(dynamic event) {
    bool _isMultiDay = startDateTime.isSameDayAs(endDateTime) == false;
    var startDate = event['startDateTime'] == null
        ? null
        : DateTime.tryParse(event['startDateTime']);
    var endDate = event['endDateTime'] == null
        ? null
        : DateTime.tryParse(event['endDateTime']);

    if (endDate == null && startDate != null) {
      endDate = startDate;
    }

    backgroundColor = event['backgroundColor'];
    textColor = event['textColor'];
    title = event['title'];
    trailing = event['trailing'];
    startDateTime = startDate;
    endDateTime = endDate;
    location = event['location'];
    description = event['description'];
    isMultiDay = _isMultiDay;
    allDay =
        event['startDateTime'] != null && event['startDateTime'].length == 10;
  }

  EventEntryModel copyWithStartAndEndDates(
      DateTime startDateTime, DateTime endDateTime,
      [bool allDay]) {
    return EventEntryModel(
        backgroundColor: this.backgroundColor,
        textColor: this.textColor,
        title: this.title,
        trailing: this.trailing,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        location: this.location,
        description: this.description,
        isMultiDay: startDateTime.isSameDayAs(endDateTime) == false,
        allDay: allDay != null ? allDay : this.allDay);
  }

  String date() {
    final DateFormat dateFormat = DateFormat('MMMM d, y');
    return startDateTime == null ? '' : dateFormat.format(startDateTime);
  }

  String get dateLong {
    DateFormat dateFormat = DateFormat('EEEEE, MMMM d');
    return startDateTime == null ? '' : dateFormat.format(startDateTime);
  }

  String ymd() {
    final DateFormat dateFormat = DateFormat('y-MM-dd');
    return startDateTime == null ? '' : dateFormat.format(startDateTime);
  }

  String time() {
    final DateFormat timeFormat = DateFormat.jm();
    if (startDateTime == null) {
      return '';
    }

    if (endDateTime == null) {
      return timeFormat.format(startDateTime);
    }

    // both start and end dates are specified
    var start = timeFormat.format(startDateTime);
    var end = timeFormat.format(endDateTime);

    return '$start - $end';
  }

  // Replicate a multi day entry
  List<EventEntryModel> sequence() {
    var start = startDateTime.copyWithHMS(0, 0, 0);
    var end = endDateTime.copyWithHMS(0, 0, 0);

    List<EventEntryModel> _list = [];
    // add this instance to the begining of the sequence
    _list.add(this);

    var diff = end.difference(start);
    var days = diff.inDays;
    for (var i = 0; i < days; i++) {
      var date = start.add(Duration(days: i + 1));
      if (date.isWeekend()) {
        continue;
      }
      var endDate = date;
      // if this is the last occurence,  we need to take the original end date and put it on this `model` object
      if (i + 1 == days) {
        endDate = this.endDateTime;
      }
      var model = this.copyWithStartAndEndDates(date, endDate);
      _list.add(model);
    }

    return _list;
  }

  Map<String, dynamic> toMap() {
    return {
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'title': title,
      'trailing': trailing,
      'startDateTime': startDateTime.toString(),
      'endDateTime': endDateTime.toString(),
      'location': location,
      'description': description,
      'isMultiDay': isMultiDay,
      'allDay': allDay,
    };
  }

  @override
  String toString() {
    return json.encode(toMap());
  }
}
