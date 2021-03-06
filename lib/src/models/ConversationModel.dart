import 'dart:convert';

import 'package:client_portal_app/src/models/AvatarModel.dart';
import 'package:client_portal_app/src/models/MessageModel.dart';
import 'package:client_portal_app/src/models/PersonModel.dart';

class ConversationModel {
  final String id;
  final DateTime startedDate;
  final String subject;
  final List<MessageModel> messages;
  final String messagePreview;
  final PersonModel owner;

  ConversationModel({
    this.id,
    this.startedDate,
    this.subject,
    this.messages,
    this.messagePreview,
    this.owner,
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
      owner: _json['owner'] == null
          ? PersonModel()
          : PersonModel.fromMap(_json['owner']),
    );
  }

  factory ConversationModel.fromJson(String value) {
    var _json = json.decode(value);
    return ConversationModel.fromMap(_json);
  }

  ConversationModel copyWithMessages(List<MessageModel> messages) {
    var _messages = this.messages;
    _messages.addAll(messages);
    return ConversationModel(
      id: this.id,
      startedDate: this.startedDate,
      subject: this.subject,
      owner: this.owner,
      messages: _messages,
    );
  }

  String get lastMessageId {
    return lastMessage != null ? lastMessage.id.toString() : '0';
  }

  MessageModel get lastMessage {
    if (messages.length == 0) {
      return MessageModel();
    }
    var last = messages.last;
    var first = messages.first;

    if (last.date.isAfter(first.date)) {
      return last;
    }

    return first;
  }

  MessageModel lastMessageNotMine(String me) {
    if (me == null || me.length == 0) {
      return null;
    }
    return messages.length > 0
        ? messages.lastWhere((element) {
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
    return lastMessage != null ? lastMessage.humanReadableTimestamp : '';
  }

  PersonModel identity(me) {
    // if the owner of the conversation is not me then use that
    if (owner != null && owner.id != me) {
      return owner;
    }

    if (lastMessage != null) {
      return lastMessage.author;
    }

    return PersonModel(avatar: AvatarModel(text: ''), name: '', title: '');
  }

  bool get read {
    // @todo
    return true;
  }

  @override
  String toString() {
    return json.encode({
      'id': id,
      'started_date': startedDate.toString(),
      'subject': subject,
      //'messages': messages,
    });
  }
}
