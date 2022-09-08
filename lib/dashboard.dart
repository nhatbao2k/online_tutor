import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/module/home/home_page.dart';
import 'package:online_tutor/module/profile/profile_page.dart';
import 'package:online_tutor/res/languages/languages.dart';

class Dashboard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard>{
  int _selectdIndex = 0;
  Widget _getBody(){
    if(this._selectdIndex == 0){
      return HomePage();
    }else if(_selectdIndex == 1){
      return HomePage();
    }else if(_selectdIndex == 1){
      return HomePage();
    }else if(_selectdIndex == 1){
      return HomePage();
    }else {
      return ProfilePage();
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