import 'dart:convert';

class AvatarModel {
  final String url;
  final String text;

  AvatarModel({this.url, this.text});

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      return AvatarModel(text: map['text'], url: map['url']);
    }
    return AvatarModel();
  }

  @override
  String toString() {
    return json.encode({
      url: url,
      text: text,
    });
  }
}
