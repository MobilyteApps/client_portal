import 'dart:convert';

import 'package:client_portal_app/src/models/PersonModel.dart';
import 'package:intl/intl.dart';

class MessageModel {
  final DateTime date;
  final String message;
  final PersonModel author;
  final bool read;
  final DateFormat dateFormatLong = DateFormat.yMMMMd('en_US').add_jm();
  final DateFormat timeOnlyFormat = DateFormat.jm();

  MessageModel({this.message, this.author, this.date, this.read});

  factory MessageModel.fromJson(String value) {
    var _json = json.decode(value);
    return MessageModel.fromMap(_json);
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      date: map['date'] == null ? null : DateTime.tryParse(map['date']['date']),
      message: map['message'],
      author: PersonModel.fromMap(map['author']),
    );
  }

  MessageModel copyWith({
    String subject,
    String message,
    PersonModel author,
    bool read,
  }) {
    return MessageModel(
      message: message != null ? message : this.message,
      author: author != null ? author : this.author,
      read: read != null ? read : this.read,
    );
  }

  String get humanReadableTimestamp {
    if (date == null) {
      return '';
    }
    var now = DateTime.now();
    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return timeOnlyFormat.format(date);
    }

    return dateFormatLong.format(date);
  }
}
