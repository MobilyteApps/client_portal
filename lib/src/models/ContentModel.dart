import 'dart:convert';


class ContentModel {
  final int icon;
  final String title;
  final String slug;

  ContentModel(
      {this.title, this.icon, this.slug});

  factory ContentModel.fromJson(dynamic data) {
    var _json = json.decode(data);
    return ContentModel.fromMap(_json);
  }

  factory ContentModel.fromMap(Map<dynamic, dynamic> map) {
    return ContentModel(
      icon: map['icon'],
      title: map['title'],
      slug: map['slug'],
    );
  }
}
