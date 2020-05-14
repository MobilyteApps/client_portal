import 'package:intl/intl.dart';

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
  String startDateTime;
  String endDateTime;
  String location;
  String description;
  bool isMultiDay;
  bool allDay;

  EventEntryModel.fromJson(dynamic event) {
    var startDate = event['startDateTime'] == null
        ? null
        : DateTime.tryParse(event['startDateTime']);

    var endDate = event['endDateTime'] == null
        ? null
        : DateTime.tryParse(event['endDateTime']);

    bool sameDay(DateTime start, DateTime end) {
      return start.day == end.day &&
          start.month == end.month &&
          start.year == end.year;
    }

    bool _isMultiDay = false;
    if (endDate != null && sameDay(startDate, endDate) == false) {
      _isMultiDay = true;
    }

    backgroundColor = event['backgroundColor'];
    textColor = event['textColor'];
    title = event['title'];
    trailing = event['trailing'];
    startDateTime = event['startDateTime'];
    endDateTime = event['endDateTime'];
    location = event['location'];
    description = event['description'];
    isMultiDay = _isMultiDay;
    allDay =
        event['startDateTime'] != null && event['startDateTime'].length == 10;
  }

  String date() {
    final DateFormat dateFormat = DateFormat('MMMM d, y');
    return startDateTime == null
        ? ''
        : dateFormat.format(DateTime.parse(startDateTime));
  }

  String ymd() {
    final DateFormat dateFormat = DateFormat('y-MM-dd');
    return startDateTime == null
        ? ''
        : dateFormat.format(DateTime.parse(startDateTime));
  }

  String time() {
    final DateFormat timeFormat = DateFormat.jm();
    if (startDateTime == null) {
      return '';
    }

    if (endDateTime == null) {
      return timeFormat.format(DateTime.parse(startDateTime));
    }

    // both start and end dates are specified
    var start = timeFormat.format(DateTime.parse(startDateTime));
    var end = timeFormat.format(DateTime.parse(endDateTime));

    return '$start - $end';
  }
}
