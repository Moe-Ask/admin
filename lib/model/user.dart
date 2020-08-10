import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moeask/api/user.dart';

class User {

  static User current;

  String avatarUrl;
  int createTime;
  String description;
  String email;
  String ip;
  int lastTime;
  String nickname;
  String permissions;
  String tel;
  int userId;
  String username;

  String token;

  User(this.token);

  Map<String, dynamic> decodeJwt() {
    if (token == null)
      return {};
    return JwtDecoder.decode(token);
  }

  Future sync() async {
    var json = await me(token);
    avatarUrl = json['avatar_url'];
    createTime = json['create_time'];
    description = json['description'];
    email = json['email'];
    ip = json['ip'];
    lastTime = json['last_time'];
    nickname = json['nickname'];
    permissions = json['permissions'];
    tel = json['tel'];
    userId = json['user_id'];
    username = json['username'];
  }

  Future save() async {
    LocalStorageInterface prefs = await LocalStorage.getInstance();
    await prefs.setString("token", token);
  }

  static Future logout() async {
    LocalStorageInterface prefs = await LocalStorage.getInstance();
    await prefs.remove("token");
    current = null;
  }

  static Future<User> getUser() async {
    LocalStorageInterface prefs = await LocalStorage.getInstance();
    if (prefs.containsKey("token")) {
      var user = User(prefs.getString("token"));
      await user.sync();
      return user;
    } else {
      return null;
    }
  }
}