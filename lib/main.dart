import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moeask/api/admin.dart';
import 'package:moeask/model/system_info.dart';
import 'package:moeask/pages/login.dart';
import 'package:moeask/widgets.dart';

import 'model/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '布好辣',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primaryColor: Color(Colors.pink.value),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Oh my ga!'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: User.getUser(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return loginWidget(this);
            }
            User.current = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.flight_land),
                      tooltip: "Logout",
                      onPressed: () {
                        User.logout().then((value) => this.setState(() {}));
                      }),
                  IconButton(
                      icon: const Icon(Icons.account_circle),
                      tooltip: User.current.nickname,
                      onPressed: () {})
                ],
              ),
              body: FutureBuilder(
                  future: systemInfo(User.current.token).catchError((e) {
                    showAlertSnackBar(context, e.toString());
                  }),
                  builder: (BuildContext context,
                      AsyncSnapshot<SystemInfo> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      ValueNotifier<SystemInfo> si =
                          ValueNotifier(snapshot.data);
                      Timer.periodic(Duration(seconds: 3), (timer) async {
                        si.value = await systemInfo(User.current.token);
                      });
                      return ValueListenableBuilder(
                          valueListenable: si,
                          builder:
                              (BuildContext context, SystemInfo si, child) {
                            return Container(
                                margin: EdgeInsets.all(20),
                                child: GridView.extent(
                                  primary: true,
                                  maxCrossAxisExtent: 500,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.green),
                                        padding: const EdgeInsets.all(10),
                                        child: AutoSizeText(
                                          "运行时间: ${(si.operationTime / 60 / 60).toStringAsFixed(2)}h",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey),
                                      padding: const EdgeInsets.all(10),
                                      child: AutoSizeText(
                                        "内存: ${(si.memoryStats.heapAlloc / 1024 / 1024).toStringAsFixed(2)}MB / ${(si.memoryStats.sys / 1024 / 1024).toStringAsFixed(2)}MB",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.red),
                                      padding: const EdgeInsets.all(10),
                                      child: AutoSizeText(
                                        "上次GC: ${DateFormat("Hms").format(DateTime.fromMicrosecondsSinceEpoch((si.memoryStats.lastGc / 1000).round()))} / ${(si.memoryStats.pauseTotalNs / 1000 / 1000).toStringAsFixed(2)}ms",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          color: Colors.redAccent),
                                      padding: const EdgeInsets.all(10),
                                      child: AutoSizeText(
                                        "GC次数: ${si.memoryStats.numGc}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ));
                          });
                    } else {
                      return SizedBox();
                    }
                  }),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                tooltip: '未定',
                child: Icon(Icons.add),
              ),
            );
          } else {
            return SizedBox();
          }
        });
  }
}
