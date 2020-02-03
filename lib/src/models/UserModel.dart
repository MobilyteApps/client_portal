import "package:scoped_model/scoped_model.dart";

class UserModel extends Model {
  String username;
  int id;

  bool isAuthenticated() {
    return this.id != null;
  }

  bool login(dynamic body) {
    this.username = body['username'];
    this.id = int.parse(body['id']);
    print('login from user model');
    print(body);
    notifyListeners();
    // @todo login logic
    return true;
  }
}
