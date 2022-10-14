import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/single_state.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/class_detail_product_page.dart';
import 'package:online_tutor/module/class/model/class_course.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/class/model/my_class_detail.dart';
import 'package:online_tutor/module/class/presenter/class_detail_admin_presenter.dart';
import 'package:online_tutor/module/lession/lession_admin_page.dart';

import '../../common/image_load.dart';
import 'model/lession.dart';

class ClassDetailAdminPage extends StatefulWidget {
  MyClass? _myClass;
  ClassCourse? _course;
  String? _role;
  ClassDetailAdminPage(this._myClass, this._course, this._role);

  @override
  State<ClassDetailAdminPage> createState() => _ClassDetailAdminPageState(_myClass, _course, _role);
}

class _ClassDetailAdminPageState extends State<ClassDetailAdminPage> {
  MyClass? _myClass;
  ClassCourse? _course;
  String? _role;
  _ClassDetailAdminPageState(this._myClass, this._course, this._role);
  Stream<QuerySnapshot>? _stream;
  MyClassDetail? _myClassResult;
  ClassDetailAdminPresenter? _presenter;
  @override
  void initState() {
    _presenter = ClassDetailAdminPresenter();
    _stream =  FirebaseFirestore.instance.collection('class_detail').where('idClass', isEqualTo: '${_myClass!.idClass!}').snapshots();
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
          CustomAppBar(appType: AppType.child, title: Languages.of(context).classDetail),
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
                      }else if(!snapshot.hasData){
                        return NoDataView(Languages.of(context).noData);
                      }else{
                        snapshot.data!.docs.forEach((element) {
                          _myClassResult = MyClassDetail.fromJson(element.data());
                        });
                        if(_myClassResult!=null){
                          _presenter!.loadData(true);
                        }

                        return _myClassResult!=null?Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _header(),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                              child: CustomText(Languages.of(context).lessionList, textStyle: TextStyle(fontSize: 18, color: CommonColor.black)),
                            ),
                            Wrap(
                              children: List.generate(_myClassResult!.lession!.length, (index) => _itemLession(_myClassResult!.lession![index])),
                            )
                          ],
                        ):SizedBox();
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: CommonKey.TEACHER==_role||CommonKey.ADMIN==_role,
        child: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailProductPage(_myClass, _course, _presenter!.state==SingleState.HAS_DATA?CommonKey.EDIT:'',_presenter!.state==SingleState.HAS_DATA?_myClassResult:null))),
          child: Observer(
            builder: (_){
              if(_presenter!.state==SingleState.LOADING){
                return Icon(Icons.add, color: CommonColor.white,);
              }else if(_presenter!.state==SingleState.NO_DATA){
                return Icon(Icons.add, color: CommonColor.white,);
              }else{
                return Icon(Icons.edit, color: CommonColor.white,);
              }
            },
          )
        ),
      ),
    );
  }

  Widget _itemLession(Lession lession){

    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>LessionAdminPage(lession, CommonKey.ADMIN, _myClassResult, _myClass, _course, _role))),
      child: Container(
        width: getWidthDevice(context),
        color: CommonColor.white,
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 8,),
            Icon(Icons.circle_outlined, color: CommonColor.blue,),
            SizedBox(width: 4,),
            Expanded(child: CustomText('${lession.nameLession}', textStyle: TextStyle(fontSize: 14, color: CommonColor.blue))),
            Icon(Icons.access_time_filled, color: CommonColor.blue,),
            SizedBox(width: 8,),
          ],
        ),
      ),
    );
  }

  Widget _header(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageLoad.imageNetwork(_myClassResult!.imageLink, checkLandscape(context)?getWidthDevice(context)/3:getHeightDevice(context)/3, getWidthDevice(context)),
        SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(_myClassResult!.nameClass!, textStyle: TextStyle(color: CommonColor.black, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: ()=>null, icon: Icon(Icons.info, color: CommonColor.blue,)),
            Expanded(child: CustomText(Languages.of(context).infor, textStyle: TextStyle(fontSize: 14, color: CommonColor.blue))),
            TextButton(
              onPressed: ()=>null,
              child: CustomText(Languages.of(context).rating, textStyle: TextStyle(fontSize: 14, color: CommonColor.orangeLight)),
            ),
            SizedBox(width: 8,),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
          child: CustomText(_myClassResult!.describe!=null?_myClassResult!.describe!:Languages.of(context).noData, textStyle: TextStyle(color: CommonColor.blue, fontSize: 16)),
        ),
        Divider(),
        SizedBox(height: 8,),
      ],
    );
  }
}
