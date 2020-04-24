import 'dart:convert';

import 'package:client_portal_app/src/models/MessageModel.dart';
import 'package:intl/intl.dart';

class ConversationModel {
  final String id;
  final DateTime startedDate;
  final String subject;
  final List<MessageModel> messages;
  final String messagePreview;
  final DateFormat dateFormatLong = DateFormat.yMMMMd('en_US').add_jm();
  final DateFormat timeOnlyFormat = DateFormat.jm();

  ConversationModel({
    this.id,
    this.startedDate,
    this.subject,
    this.messages,
    this.messagePreview,
  });

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    DateTime _createDate(value) {
      return value == null ? value : DateTime.parse(value);
    }

    List<MessageModel> _mapMessages(List<Map<String, dynamic>> messages) {
      return messages.map((e) {
        return MessageModel.fromMap(e);
      }).toList();
    }

    var _json = map;

    var _messagePreview;

    var _messages = [];

    if (_json['messages'] != null && _json['messages'].length > 0) {
      _messagePreview = _json['messages'].first['message'];
      _messages =
          _mapMessages(List<Map<String, dynamic>>.from(_json['messages']));
    }

    return ConversationModel(
      id: _json['id'].toString(),
      startedDate: _createDate(_json['started_date']['date']),
      subject: _json['subject'],
      messagePreview: _messagePreview,
      messages: _messages,
    );
  }

  factory ConversationModel.fromJson(String value) {
    var _json = json.decode(value);
    return ConversationModel.fromMap(_json);
  }

  MessageModel get lastMessage {
    return messages.length > 0 ? messages.last : MessageModel();
  }

  MessageModel lastMessageNotMine(String me) {
    if (me == null || me.length == 0) {
      return null;
    }
    return messages.length > 0
        ? messages.lastWhere((element) {
            print(me);
            return element.author.id != me;
          }, orElse: () => null)
        : null;
  }

  DateTime get lastMessageDate {
    if (lastMessage == null) {
      return null;
    }
    return lastMessage.date;
  }

  String get humanReadableTimestamp {
    if (lastMessageDate == null) {
      return '';
    }
    var now = DateTime.now();
    if (now.day == lastMessageDate.day &&
        now.month == lastMessageDate.month &&
        now.year == lastMessageDate.year) {
      return timeOnlyFormat.format(lastMessageDate);
    }

    return dateFormatLong.format(lastMessageDate);
  }
}
