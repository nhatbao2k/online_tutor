import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/class_add_page.dart';
import 'package:online_tutor/module/class/class_detail_admin_page.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/class/presenter/class_add_presenter.dart';

import 'model/class_course.dart';

class ClassPage extends StatefulWidget {
  final ClassCourse? _course;
  String? _role;
  String? _keyFlow;
  ClassPage(this._course, this._role, this._keyFlow);

  @override
  State<ClassPage> createState() => _ClassPageState(_course, _role, _keyFlow);
}

class _ClassPageState extends State<ClassPage> {
  final ClassCourse? _course;
  String? _role;
  String _username='';
  String? _keyFlow;
  _ClassPageState(this._course, this._role, this._keyFlow);
  Stream<QuerySnapshot>? _stream;
  ClassAddPresenter? _presenter;

  @override
  void initState() {
    _presenter = ClassAddPresenter();
    if(_course==null){
      _stream = FirebaseFirestore.instance.collection('class').snapshots();
    }else{
      _stream = FirebaseFirestore.instance.collection('class').where('idCourse', isEqualTo: _course!.getIdCourse).snapshots();
    }
    getUserInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonKey.DASH_BOARD==_keyFlow?CustomAppBar(appType: AppType.appbar_home, title: Languages.of(context).appName):CustomAppBar(appType: AppType.child, title: Languages.of(context).myClass),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return LoadingView();
                      }else if(snapshot.hasError){
                        return NoDataView(Languages.of(context).noData);
                      }else{
                        return Wrap(
                          children:snapshot.data!.docs.map((e) {
                            Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
                            List<dynamic> register = data['subscribe'];
                            return (CommonKey.TEACHER==_role||CommonKey.ADMIN==_role)?itemCourseAdminHours(context, data['nameClass'], data['teacherName'],
                                data['imageLink'], '${
                                CommonKey.MON==data['startDate']
                                    ? Languages.of(context).monday
                                    :CommonKey.TUE==data['startDate']
                                    ? Languages.of(context).tuesday
                                    :CommonKey.WED==data['startDate']
                                    ? Languages.of(context).wednesday
                                    :CommonKey.THU==data['startDate']
                                    ? Languages.of(context).thurday
                                    :CommonKey.FRI==data['startDate']
                                    ? Languages.of(context).friday
                                    :CommonKey.SAT==data['startDate']
                                    ? Languages.of(context).saturday
                                    :Languages.of(context).sunday
                                } - ${data['startHours']}',
                                    (onClickEdit) => Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassAddPage(_course, CommonKey.EDIT, data))),
                                    (onClickDelete) => _presenter!.deleteClass(data['idClass']),
                                    (click) => Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailAdminPage(MyClass(idClass: data['idClass'], teacherName: data['teacherName'], nameClass: data['nameClass']), _course, _role))))
                            :itemCourseHours(context, data['nameClass'], data['teacherName'], data['imageLink'], (id) => {
                              register.contains(_username)
                                  ?Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailAdminPage(MyClass(idClass: data['idClass'], teacherName: data['teacherName'], nameClass: data['nameClass']), _course, _role)))
                                  :showToast(Languages.of(context).requireClass)
                            },'${
                                CommonKey.MON==data['startDate']
                                    ? Languages.of(context).monday
                                    :CommonKey.TUE==data['startDate']
                                    ? Languages.of(context).tuesday
                                    :CommonKey.WED==data['startDate']
                                    ? Languages.of(context).wednesday
                                    :CommonKey.THU==data['startDate']
                                    ? Languages.of(context).thurday
                                    :CommonKey.FRI==data['startDate']
                                    ? Languages.of(context).friday
                                    :CommonKey.SAT==data['startDate']
                                    ? Languages.of(context).saturday
                                    :Languages.of(context).sunday
                            } - ${data['startHours']}', () {
                              if(!register.contains(_username)){
                                register.add(_username);
                                _presenter!.RegisterClass(data['idClass'], register, data['idCourse']);
                              }
                            },register.contains(_username)?false:true);
                          }).toList(),
                        );
                      }
                    },
                  )
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: CommonKey.ADMIN==_role||CommonKey.TEACHER==_role,
        child: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassAddPage(_course,'',null))),
          child: Icon(Icons.add, color: CommonColor.white,),
        ),
      ),
    );
  }

  Future<void> getUserInfor() async{
    _username = await _presenter!.getUserInfo();
    setState(()=>null);
    if(CommonKey.MEMBER==_role&&CommonKey.DASH_BOARD==_keyFlow){
      _stream=FirebaseFirestore.instance.collection('class').where('subscribe', arrayContains: _username).snapshots();
      print(_username);
    }

  }
}
