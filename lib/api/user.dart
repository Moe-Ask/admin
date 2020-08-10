import 'package:moeask/api/http.dart';

Future<Map<String, dynamic>> me(String token) async {
  var data = await get("/me", headers: {
    "Authorization": "Bearer $token"
  });
  return data;
}