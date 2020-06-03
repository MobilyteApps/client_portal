import 'dart:convert';

import 'package:client_portal_app/src/models/AvatarModel.dart';

class PersonModel {
  final String name;
  final String title;
  final String id;
  final AvatarModel avatar;
  final bool messagingOptIn;

  PersonModel(
      {this.name, this.title, this.id, this.avatar, this.messagingOptIn});

  factory PersonModel.fromJson(String data) {
    var _json = json.decode(data);
    return PersonModel.fromMap(_json);
  }

  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      name: map['name'],
      title: map['title'],
      id: map['id'].toString(),
      avatar: AvatarModel.fromMap(map['avatar']),
      messagingOptIn: map['messagingOptIn'],
    );
  }
}
