import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/dashboard.dart';
import 'package:online_tutor/module/login/login_page.dart';
import 'package:online_tutor/res/images/image_view.dart';
import 'package:online_tutor/storage/shared_preferences.dart';

class SplashPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: CommonColor.blueLight,
      ),
      body: Container(
        height: getHeightDevice(context),
        width: getWidthDevice(context),
        child: Stack(
          children: [
            Image.asset(
              ImageView.splash,
              height: getHeightDevice(context),
              width: getWidthDevice(context),
              fit: BoxFit.fill,
            ),
            LoadingView(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    Timer(Duration(seconds: 5), (){
      getData();
    });
  }

  Future<void> getData() async{
    // dynamic user = await SharedPreferencesData.GetData(CommonKey.USERNAME);
    // String username = user.toString();
    // if(username.isNotEmpty){
    bool checkLogin = false;
    dynamic username = await SharedPreferencesData.GetData(CommonKey.USERNAME);
    if(username.toString().isNotEmpty){
      checkLogin=true;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(checkLogin)));
    // FirebaseAuth.instance
    //     .authStateChanges()
    //     .listen((User? user) {
    //   if (user == null) {
    //     checkLogin = false;
    //   } else {
    //     checkLogin = true;
    //   }
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(checkLogin)));
    // });
  }
}