import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/module/advise/advise_page.dart';
import 'package:online_tutor/module/course/course_page.dart';
import 'package:online_tutor/module/home/home_page.dart';
import 'package:online_tutor/module/login/login_page.dart';
import 'package:online_tutor/module/profile/profile_page.dart';
import 'package:online_tutor/module/schedule/schedule_page.dart';
import 'package:online_tutor/module/social/news/news_page.dart';

class Dashboard extends StatefulWidget{
  bool? _checkLogin;
  String? _role;
  Dashboard(this._checkLogin, this._role);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Dashboard(_checkLogin, _role);
  }
}

class _Dashboard extends State<Dashboard>{
  bool? _checkLogin;
  int _selectdIndex = 2;
  String? _role;
  _Dashboard(this._checkLogin, this._role);

  @override
  void initState() {

  }
  Widget _getBody(){
    if(this._selectdIndex == 0){
      return _checkLogin!?SchedulePage():LoginPage();
    }else if(_selectdIndex == 1){
      return _checkLogin!?CoursePage(_role):LoginPage();
    }else if(_selectdIndex == 2){
      return HomePage(_role);
    }else if(_selectdIndex == 3){
      return _checkLogin!?NewPages():LoginPage();
    }else {
      return _checkLogin!?ProfilePage():LoginPage();
    }
  }

  void onTapBottomMenu(int index){
    setState(() {
      _selectdIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: CommonColor.blue,
        ),
        body: _getBody(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectdIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range_sharp),
              label: 'Lịch học'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.class_),
                label: 'Lớp học'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_sharp),
                label: 'Trang chủ'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.social_distance),
                label: 'Tương tác'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Cá nhân'
            )
          ],
          onTap: (int index){
            onTapBottomMenu(index);
          },
        ),
      ),
    );
  }
}