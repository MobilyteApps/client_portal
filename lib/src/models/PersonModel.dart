class PersonModel {
  final String name;
  final String title;
  final String id;
  final String avatar;

  PersonModel({this.name, this.title, this.id, this.avatar});

  factory PersonModel.fromJson(data) {
    return PersonModel(
      name: data['name'],
      title: data['title'],
      id: data['id'],
      avatar: data['avatar'],
    );
  }
}
