import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'models/UserModel.dart';

class Api {
  final String baseUrl;

  Api({this.baseUrl});

  Future<http.Response> login(username, password, bool rememberMe) {
    Map<String, dynamic> body = {
      'username': username,
      'password': password,
      'remember': rememberMe ? '1' : '0'
    };
    return http.post('$baseUrl/user/login', body: body);
  }

  Future<http.Response> project() {
    return http.get('$baseUrl/project', headers: authorizationHeaders());
  }

  Map<String, String> authorizationHeaders() {
    UserModel user = Hive.box('identity').get(0);
    return {'Authorization': 'Bearer ${user.accessToken}'};
  }
}
