import 'dart:convert';


class ContentModel {
  final String title;
  final String file;

  ContentModel(
      {this.title, this.file });

  factory ContentModel.fromJson(dynamic data) {
    var _json = json.decode(data);
    return ContentModel.fromMap(_json);
  }

  factory ContentModel.fromMap(Map<dynamic, dynamic> map) {
    return ContentModel(
      title: map['title'],
      file: map['file'],
    );
  }
}
