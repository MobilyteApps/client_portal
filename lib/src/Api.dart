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

  Future<http.Response> projectLog() {
    return http.get('$baseUrl/project/log', headers: authorizationHeaders());
  }

  Future<http.Response> upNext() {
    return http.get('$baseUrl/schedule', headers: authorizationHeaders());
  }

  Future<http.Response> me() {
    return http.get('$baseUrl/user/me', headers: authorizationHeaders());
  }

  Future<http.Response> schedule() {
    return http.get('$baseUrl/schedule/events',
        headers: authorizationHeaders());
  }

  Map<String, String> authorizationHeaders() {
    UserModel user = Hive.box('identity').get(0);
    if (user == null) {
      return null;
    }
    String token = user == null ? '' : user.accessToken;
    return {'Authorization': 'Bearer $token'};
  }
}
