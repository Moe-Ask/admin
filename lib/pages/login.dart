import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moeask/api/login.dart';
import 'package:moeask/main.dart';
import 'package:moeask/model/captcha.dart';
import 'package:moeask/model/user.dart';
import 'package:moeask/widgets.dart';

Widget loginWidget(HomePageState homePage) {
  String username, password, _captcha, idKey;

  ValueNotifier flag = ValueNotifier(false);

  Function refreshCaptcha = () => flag.value = !flag.value;

  var onSubmit = (BuildContext context) => (s) {
        login(username, password, idKey, _captcha).then((User user) {
          if (!user.decodeJwt()["is_admin"]) {
            showAlertSnackBar(context, "用户不存在");
            refreshCaptcha();
          }
          user.sync().then((value) {
            user.save();
            // ignore: invalid_use_of_protected_member
            homePage.setState(() {});
          });
        }).catchError((e) {
          showAlertSnackBar(context, "登录时错误: ${e.toString()}");
          refreshCaptcha();
        });
      };

  return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Builder(
          builder: (context) => Center(
              child: Container(
                  width: 700,
                  padding: EdgeInsets.all(17),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70, width: 0.5)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: TextField(
                              onChanged: (s) => username = s,
                              onSubmitted: onSubmit(context),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "用户名/邮箱"))),
                      SizedBox(height: 10),
                      Flexible(
                          child: TextField(
                              onChanged: (s) => password = s,
                              onSubmitted: onSubmit(context),
                              obscureText: true,
                              obscuringCharacter: '喵',
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "密码"))),
                      SizedBox(height: 10),
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                                child: TextField(
                                    onChanged: (s) => _captcha = s,
                                    onSubmitted: onSubmit(context),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "验证码"))),
                            SizedBox(width: 30),
                            Flexible(
                                child: ValueListenableBuilder(
                                    valueListenable: flag,
                                    builder: (BuildContext context, value,
                                        Widget child) {
                                      return FutureBuilder(
                                          future: captcha().catchError((e) {
                                            showAlertSnackBar(context,
                                                "获取验证码错误: ${e.toString()}");
                                          }),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<Captcha> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              idKey = snapshot.data.idKey;
                                              var imageBytes = base64.decode(
                                                  snapshot.data.captchaImage
                                                      .split(",")[1]);
                                              return GestureDetector(
                                                onTap: refreshCaptcha,
                                                child: Image.memory(imageBytes)
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          });
                                    }))
                          ],
                        ),
                      )
                    ],
                  )))));
}
