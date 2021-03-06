import 'package:client_portal_app/src/models/MessageModel.dart';
import 'package:eventsource/eventsource.dart';
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
   // print("${'$baseUrl/user/login'}==========$body");
    return http.post(Uri.parse('$baseUrl/user/login'), body: body);
  }

  Future<http.Response> pinLogin(String code, String pin) {
    Map<String, dynamic> body = {
      'username': code,
      'password': pin,
    };
    return http.post(Uri.parse('$baseUrl/user/pin'), body: body);
  }

  Future<http.Response> project() {
    print('[Api.dart] requesting project');
    return http.get(Uri.parse('$baseUrl/project'), headers: authorizationHeaders());
  }

  Future<http.Response> projectLog() {
    return http.get(Uri.parse('$baseUrl/project/log'), headers: authorizationHeaders());
  }

  Future<http.Response> upNext() {
    return http.get(Uri.parse('$baseUrl/schedule'), headers: authorizationHeaders());
  }

  Future<http.Response> me() {
    print('[Api.dart] requesting identity');
    return http.get(Uri.parse('$baseUrl/user/me'), headers: authorizationHeaders());
  }

  Future<http.Response> schedule() {
    return http.get(Uri.parse('$baseUrl/schedule/events'),
        headers: authorizationHeaders());
  }

  Future<http.Response> recentConversations() {
    return http.get(Uri.parse('$baseUrl/conversation/recent'),
        headers: authorizationHeaders());
  }

  Future<http.Response> allConversations([int before]) {
    var url = '$baseUrl/conversation';
    if (before != null) {
      url += '?before=$before';
    }
    return http.get(Uri.parse(url), headers: authorizationHeaders());
  }

  Future<http.Response> getConversation(String id) {
    var url = '$baseUrl/conversation/view?id=$id';
    return http.get(Uri.parse(url), headers: authorizationHeaders());
  }

  Future<http.Response> newConversation(
      String subject, MessageModel messageModel, String to) {
    var url = '$baseUrl/conversation/new';
    var body = {
      'subject': subject,
      'to': to,
      'message': messageModel.message,
    };
    return http.post(Uri.parse(url), headers: authorizationHeaders(), body: body);
  }

  Future<http.Response> markConversationAsRead(String conversationId) {
    var body = {
      'conversationId': conversationId,
    };
    return http.post(Uri.parse(
      '$baseUrl/conversation/mark-as-read'),
      headers: authorizationHeaders(),
      body: body,
    );
  }

  Future<http.Response> replyToConversation(
      String conversationId, String reply) {
    var body = {'conversationId': conversationId, 'reply': reply};
    return http.post(Uri.parse('$baseUrl/conversation/reply'),
        body: body, headers: authorizationHeaders());
  }

  Future<http.Response> team() {
    return http.get(Uri.parse('$baseUrl/team'), headers: authorizationHeaders());
  }

  Future<http.Response> document() {
    return http.get(Uri.parse('$baseUrl/content/'), headers: authorizationHeaders());
  }
  Future<http.Response> whatExpect(){
    return http.get(Uri.parse('$baseUrl/content/page?pageId=what_to_expect'), headers: authorizationHeaders());
  }
  Future<http.Response> workScope(){
    return http.get(Uri.parse('$baseUrl/content/page?pageId=work_scope'), headers: authorizationHeaders());
  }
  Future<http.Response> fileContent(String fileName){
    return http.get(Uri.parse('$baseUrl/content/page?pageId=files&file=$fileName'), headers: authorizationHeaders());
  }


  Future<EventSource> conversationStream(String id) async {
    return await EventSource.connect(
        "$baseUrl/conversation/stream?id=$id&_format=text/event-stream",
        headers: authorizationHeaders());
  }

  Future<http.Response> conversationPoll(String id, int last) async {
    return await http.post(Uri.parse('$baseUrl/conversation/poll?id=$id&after=$last'),
        headers: authorizationHeaders());
  }

  Future<http.Response> requestPasswordResetCode(String email) async {
    var response =
        await http.post(Uri.parse('$baseUrl/user/request-reset'), body: {'email': email});

    processResponse(response);

    return response;
  }

  Future<http.Response> verifyResetCode(String email, String code) async {
    var response = await http.post(Uri.parse('$baseUrl/user/verify-reset-code'),
        body: {'email': email, 'code': code});

    processResponse(response);

    return response;
  }

  Future<http.Response> saveNewPassword(
      String challenge, String password) async {
    var response = await http.post(Uri.parse('$baseUrl/user/new-password'),
        body: {'challenge': challenge, 'password': password});

    processResponse(response);

    return response;
  }

  Future<http.Response> getPageContent(String pageId) async {
    var response = await http.post(Uri.parse('$baseUrl/content/page?pageId=${pageId}'),
        headers: authorizationHeaders());
    processResponse(response);
    return response;
  }

  Future<http.Response> getLastPayment() async {
    var response = await http.post(Uri.parse('$baseUrl/payment/last'),
        headers: authorizationHeaders());
    processResponse(response);
    return response;
  }

  Future<http.Response> getPreviousPayments() async {
    var response = await http.post(Uri.parse('$baseUrl/payment/previous'),
        headers: authorizationHeaders());
    processResponse(response);
    return response;
  }

  Future<http.Response> getNextPaymentDue() async {
    var response = await http.post(Uri.parse('$baseUrl/payment/next'),
        headers: authorizationHeaders());
    processResponse(response);
    return response;
  }

  Future<http.Response> getInvoices() async {
    var response = await http.post(Uri.parse('$baseUrl/invoice/all'),
        headers: authorizationHeaders());
    processResponse(response);

    return response;
  }

  Future<http.Response> saveDeviceToken(String token) async {
    var response = await http.post(Uri.parse('$baseUrl/user/device-token'),
        body: {'token': token}, headers: authorizationHeaders());

    processResponse(response);

    return response;
  }

  Future<http.Response> getBillingInfo() async {
    var response = await http.post(Uri.parse('$baseUrl/project/billing'),
        headers: authorizationHeaders());
    processResponse(response);
    return response;
  }

  Future<http.Response> paymentMethods() async {
    var response = await http.get(Uri.parse('$baseUrl/payment/methods'),
        headers: authorizationHeaders());

    processResponse(response);

    return response;
  }

  Future<http.Response> storedPaymentMethods() async {
    var response = await http.get(Uri.parse('$baseUrl/payment/stored-methods'),
        headers: authorizationHeaders());

    processResponse(response);

    return response;
  }

  Future<http.Response> updateCreditCard(details) async {
    var response = await http.post(
      Uri.parse('$baseUrl/payment/update-credit-card'),
      body: details,
      headers: authorizationHeaders(),
    );

    processResponse(response);

    return response;
  }

  Future<http.Response> updateACH(details) async {
    var response = await http.post(Uri.parse(
      '$baseUrl/payment/update-ach'),
      body: details,
      headers: authorizationHeaders(),
    );

    processResponse(response);

    return response;
  }

  void processResponse(http.Response response) {
    if (response.statusCode == 422) {
      throw Exception(response.reasonPhrase);
    }
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
