import 'dart:convert';

import 'package:http/http.dart' as http;

const MainApi = "https://api.moeask.net/v1";

http.Client _client;

http.Client client() {
  if (_client == null) {
    _client = http.Client();
  }
  return _client;
}

Future<Map<String, dynamic>> get(String path, {Map<String, String> headers}) async {
  var resp = await client().get(MainApi + path, headers: headers);
  return handleErr(resp);
}

Future<Map<String, dynamic>> post(String path, {Map<String, String> body}) async {
  var resp = await client().post(MainApi + path, body: body);
  return handleErr(resp);
}

Map<String, dynamic> handleErr(http.Response resp) {
  Map<String, dynamic> json;

  try {
    json = jsonDecode(resp.body);

    if (resp.statusCode != 200) {
      throw ApiException(resp.statusCode, json["message"].toString());
    }
  } catch (e) {
    throw ApiException(resp.statusCode, e.toString());
  }
  return json;
}

class ApiException implements Exception {
  int status;
  String message;

  ApiException(this.status, this.message);

  @override
  String toString() {
    return "Api异常: http code: $status, message: $message";
  }
}

