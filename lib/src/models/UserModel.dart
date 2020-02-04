import "package:scoped_model/scoped_model.dart";
import 'package:hive/hive.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel extends Model {
  @HiveField(0)
  int id;

  @HiveField(1)
  String accessToken;

  @HiveField(2)
  String username;

  bool isAuthenticated() {
    return this.id != null;
  }

  Future<bool> login(dynamic body) async {
    this.username = body['username'];
    this.id = int.parse(body['id']);
    this.accessToken = body['accessToken'];

    await Hive.box('identity').put(0, this);
    notifyListeners();

    return true;
  }

  Future<bool> logout() async {
    await Hive.box('identity').delete(0);
    notifyListeners();
    return true;
  }
}
