import 'package:intl/intl.dart';

class EventEntryModel {
  EventEntryModel(
      {this.backgroundColor,
      this.textColor,
      this.title,
      this.trailing,
      this.startDateTime,
      this.endDateTime,
      this.location,
      this.description});

  int backgroundColor;
  int textColor;
  String title;
  String trailing;
  String startDateTime;
  String endDateTime;
  String location;
  String description;

  EventEntryModel.fromJson(dynamic event) {
    backgroundColor = event['backgroundColor'];
    textColor = event['textColor'];
    title = event['title'];
    trailing = event['trailing'];
    startDateTime = event['startDateTime'];
    endDateTime = event['endDateTime'];
    location = event['location'];
    description = event['description'];
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
