import 'dart:convert';

import 'package:client_portal_app/src/models/PersonModel.dart';

class MessageModel {
  final DateTime date;
  final String message;
  final PersonModel author;
  final PersonModel recipient;
  final bool read;

  MessageModel(
      {this.recipient, this.message, this.author, this.date, this.read});

  factory MessageModel.fromJson(String value) {
    var _json = json.decode(value);
    return MessageModel.fromMap(_json);
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      date: map['date'] == null ? null : DateTime.tryParse(map['date']['date']),
      message: map['message'],
      author: PersonModel.fromMap(map['author']),
      recipient: PersonModel.fromMap(map['recipient']),
    );
  }

  MessageModel copyWith({
    PersonModel recipient,
    String subject,
    String message,
    PersonModel author,
    bool read,
  }) {
    return MessageModel(
      recipient: recipient != null ? recipient : this.recipient,
      message: message != null ? message : this.message,
      author: author != null ? author : this.author,
      read: read != null ? read : this.read,
    );
  }
}
