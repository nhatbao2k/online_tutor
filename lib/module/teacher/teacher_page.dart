import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/teacher/presenter/teacher_presenter.dart';
import 'package:online_tutor/module/teacher/teacher_add_page.dart';

class TeacherPage extends StatefulWidget {
  String? _role;

  TeacherPage(this._role);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {

  Stream<QuerySnapshot>? _streamTeacher;
  TeacherPresenter? _presenter;

  @override
  void initState() {
    _streamTeacher = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: CommonKey.TEACHER).where('isLooked', isEqualTo: false).snapshots();
    _presenter = TeacherPresenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonKey.ADMIN==widget._role
              ?CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).teacher, nameFunction: Languages.of(context).teacherAdd, callback: (value){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherAddPage(null, widget._role)));
          },)
          :CustomAppBar(appType: AppType.child, title: Languages.of(context).teacher),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: _streamTeacher!,
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return LoadingView();
                  }else if(snapshot.hasError){
                    return NoDataView(Languages.of(context).noData);
                  }else if(!snapshot.hasData){
                    return NoDataView(Languages.of(context).noData);
                  }else{
                    return Wrap(
                    alignment: WrapAlignment.center,
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                        return Card(
                          margin: EdgeInsets.all(8),
                          child: Container(
                            width: getWidthDevice(context)/2-16,
                            height: getHeightDevice(context)*0.35,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageLoad.imageNetwork(data['avatar'], getWidthDevice(context)/4, getWidthDevice(context)/2-32),
                                SizedBox(height: 8,),
                                CustomText('GV: ${data['fullname']}', textStyle: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2, textAlign: TextAlign.center),
                                SizedBox(height: 8,),
                                CustomText('Đ/c: ${data['address']}', textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 2),
                                SizedBox(height: 8,),
                                CustomText('Chức vụ: ${data['office']}', textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 2),
                                SizedBox(height: 8,),
                                CustomText(data['describe'], textStyle: TextStyle(fontSize: 12, overflow: TextOverflow.fade), maxline: 3),
                                Spacer(),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherAddPage(data, widget._role))),
                                      icon: Icon(
                                        Icons.edit,
                                        color: CommonColor.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        _presenter!.lookAccount(data['phone']);
                                      },
                                      icon: Icon(
                                        Icons.lock_open_sharp,
                                        color: CommonColor.blue,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
