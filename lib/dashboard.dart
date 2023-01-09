
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/module/class/class_page.dart';
import 'package:online_tutor/module/course/course_page.dart';
import 'package:online_tutor/module/home/home_page.dart';
import 'package:online_tutor/module/login/login_page.dart';
import 'package:online_tutor/module/profile/profile_page.dart';
import 'package:online_tutor/module/schedule/schedule_page.dart';
import 'package:online_tutor/module/social/news/news_page.dart';
import 'package:online_tutor/presenter/dash_board_presenter.dart';

import 'module/class/model/class_course.dart';

class Dashboard extends StatefulWidget{
  bool? _checkLogin;
  String? _role;
  String? _username;
  Dashboard(this._checkLogin, this._role, this._username);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Dashboard(_checkLogin, _role, this._username);
  }
}

class _Dashboard extends State<Dashboard>{
  bool? _checkLogin;
  int _selectdIndex = 2;
  String? _role;
  String? _username;
  ClassCourse? _course;
  _Dashboard(this._checkLogin, this._role, this._username);

  DashBoardPresenter? _presenter;
  @override
  void initState() {
    if(CommonKey.MEMBER==_role){
      _presenter=DashBoardPresenter();
      getCourse();
    }
  }
  Widget _getBody(){
    if(this._selectdIndex == 0){
      return _checkLogin!?SchedulePage(_role):LoginPage();
    }else if(_selectdIndex == 1){
      return _checkLogin!?CommonKey.MEMBER==_role?ClassPage(_course, _role, CommonKey.DASH_BOARD):CoursePage(_role,'', _username):LoginPage();
    }else if(_selectdIndex == 2){
      return HomePage(_role);
    }else if(_selectdIndex == 3){
      return _checkLogin!?NewPages():LoginPage();
    }else {
      return _checkLogin!?ProfilePage(_role):LoginPage();
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
                label: '${CommonKey.MEMBER==_role?'Lớp học':'Khoá học'}'
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

  Future<void> getCourse() async{
    _course = await _presenter!.getCourse(_username!);
  }
}