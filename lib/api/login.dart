
import 'package:moeask/api/http.dart';
import 'package:moeask/model/captcha.dart';
import 'package:moeask/model/user.dart';

Future<Captcha> captcha() async {
  var data = await get("/captcha");
  return Captcha.fromJson(data);
}

Future<User> login(String username, password, idKey, verifyValue) async {
  var data = await post("/login", body: {
    "username": username,
    "password": password,
    "id_key": idKey,
    "verify_value": verifyValue,
    "remember": true
  });
  return User(data["token"])..userId = data["user_id"];
}
