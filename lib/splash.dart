//import 'package:flare_loading/flare_loading.dart';
//import 'package:flutter/material.dart';
//import 'package:flutterappbam/main_page.dart';
//import 'package:flutterappbam/styles.dart';
//import 'dart:async';
//class Splash extends StatefulWidget {
//  @override
//  _SplashState createState() => _SplashState();
//}
//
//class _SplashState extends State<Splash> {
//
////  @override
////  void initState() {
////    // TODO: implement initState
////    super.initState();
////    Timer(Duration(seconds: 3), ()=> MainPage());
////  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        backgroundColor: mainBlack,
//        body: Container(
//          width: MediaQuery.of(context).size.width,
//          child: Center(
//            child:FlareLoading(
//              name: 'assets/Trim.flr',
//              //loopAnimation: 'Loading',
//              startAnimation: "Untitled",
//              endAnimation: 'Complete',
//              width: MediaQuery.of(context).size.width,
//              height: MediaQuery.of(context).size.height,
////              fit: BoxFit.fill,
//              until: () => Future.delayed(Duration(seconds: 2)),
//              onSuccess: (value) => Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage())),
//              onError: (err, stack) {
//                print(err);
//              },
//            ),
//          ),
//        ));
//  }
//}