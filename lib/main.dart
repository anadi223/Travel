
import 'package:flutter/material.dart';
import 'package:flutterappbam/main_page.dart';
import 'package:flutterappbam/splash.dart';
import 'package:flutterappbam/styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: mainBlack,
      ),
      home: MainPage(),
    );
  }
}