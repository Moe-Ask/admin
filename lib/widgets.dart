import 'package:flutter/material.dart';

ScaffoldFeatureController showAlertSnackBar(BuildContext context, String text) {
  return Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: TextStyle(fontSize: 17),
      textAlign: TextAlign.center
    ),
    backgroundColor: Colors.red,
  ));
}
