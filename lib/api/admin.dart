import 'package:moeask/api/http.dart';
import 'package:moeask/model/system_info.dart';

Future<SystemInfo> systemInfo(String token) async {
  var data = await get("/admin/systemInfo", headers: {
    "Authorization": "Bearer $token"
  });
  return SystemInfo.fromJson(data);
}