import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/module/home/home_page.dart';
import 'package:online_tutor/module/login/login_page.dart';
import 'package:online_tutor/module/profile/profile_page.dart';

class Dashboard extends StatefulWidget{
  bool? _checkLogin;

  Dashboard(this._checkLogin);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Dashboard(_checkLogin);
  }
}

class _Dashboard extends State<Dashboard>{
  bool? _checkLogin;
  int _selectdIndex = 2;

  _Dashboard(this._checkLogin);

  @override
  void initState() {
    getData();
  }
  Widget _getBody(){
    if(this._selectdIndex == 0){
      return _checkLogin!?ProfilePage():LoginPage();
    }else if(_selectdIndex == 1){
      return _checkLogin!?ProfilePage():LoginPage();
    }else if(_selectdIndex == 2){
      return HomePage();
    }else if(_selectdIndex == 3){
      return _checkLogin!?ProfilePage():LoginPage();
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

  Future<void> getData() async{
    // dynamic user = await SharedPreferencesData.GetData(CommonKey.USERNAME);
    // String username = user.toString();
    // if(username.isNotEmpty){
    bool checkLogin = false;
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        _checkLogin = false;
      } else {
        _checkLogin = true;
      }
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(checkLogin)));
    });
  }
}