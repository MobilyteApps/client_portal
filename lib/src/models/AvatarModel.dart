class AvatarModel {
  final String url;
  final String text;

  AvatarModel({this.url, this.text});

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(text: map['text'], url: map['url']);
  }
}
