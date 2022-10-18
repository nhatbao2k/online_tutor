import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/dashboard.dart';
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
      body: SizedBox(
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
    Timer(const Duration(seconds: 5), (){
      getData();
    });
  }

  Future<void> getData() async{
    // dynamic user = await SharedPreferencesData.GetData(CommonKey.USERNAME);
    // String username = user.toString();
    // if(username.isNotEmpty){
    bool checkLogin = false;
    String role = '';
    String phone = '';
    dynamic username = await SharedPreferencesData.GetData(CommonKey.USERNAME);
    dynamic data = await SharedPreferencesData.GetData(CommonKey.USER);
    if(username.toString().isNotEmpty){
      checkLogin=true;

      if(data!=null){
        Map<String, dynamic>json = jsonDecode(data.toString());
        role = json['role']!=null?json['role']:'';
        phone = json['phone']!=null?json['phone']:'';
      }
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(checkLogin, role, phone)));
  }
}