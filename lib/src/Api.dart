import 'package:client_portal_app/src/models/MessageModel.dart';
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
    print('[Api.dart] requesting project');
    return http.get('$baseUrl/project', headers: authorizationHeaders());
  }

  Future<http.Response> projectLog() {
    return http.get('$baseUrl/project/log', headers: authorizationHeaders());
  }

  Future<http.Response> upNext() {
    return http.get('$baseUrl/schedule', headers: authorizationHeaders());
  }

  Future<http.Response> me() {
    print('[Api.dart] requesting identity');
    return http.get('$baseUrl/user/me', headers: authorizationHeaders());
  }

  Future<http.Response> schedule() {
    return http.get('$baseUrl/schedule/events',
        headers: authorizationHeaders());
  }

  Future<http.Response> recentConversations() {
    return http.get('$baseUrl/conversation/recent',
        headers: authorizationHeaders());
  }

  Future<http.Response> allConversations([int before]) {
    var url = '$baseUrl/conversation';
    if (before != null) {
      url += '?before=$before';
    }
    return http.get(url, headers: authorizationHeaders());
  }

  Future<http.Response> getConversation(String id) {
    var url = '$baseUrl/conversation/view?id=$id';
    return http.get(url, headers: authorizationHeaders());
  }

  Future<http.Response> newConversation(
      String subject, MessageModel messageModel) {
    var url = '$baseUrl/conversation/new';
    var body = {
      'subject': subject,
      'to': messageModel.recipient.id,
      'message': messageModel.message,
    };
    return http.post(url, headers: authorizationHeaders(), body: body);
  }

  Future<http.Response> markConversationAsRead(String conversationId) {
    var body = {
      'conversationId': conversationId,
    };
    return http.post(
      '$baseUrl/conversation/mark-as-read',
      headers: authorizationHeaders(),
      body: body,
    );
  }

  Future<http.Response> team() {
    return http.get('$baseUrl/team', headers: authorizationHeaders());
  }

  Map<String, String> authorizationHeaders() {
    print('[Api.dart] finding user identity');
    UserModel user = Hive.box('identity').get(0);
    if (user == null) {
      print('[Api.dart] user identity not found');
      return null;
    } else {
      print('[Api.dart] user identity found ' + user.id.toString());
    }

    String token = user == null ? '' : user.accessToken;
    return {'Authorization': 'Bearer $token'};
  }
}
