import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/class_detail_product_page.dart';
import 'package:online_tutor/module/class/model/Lession.dart';
import 'package:online_tutor/module/class/model/class_course.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/class/model/my_class_detail.dart';

import '../../common/image_load.dart';

class ClassDetailAdminPage extends StatefulWidget {
  MyClass? _myClass;
  ClassCourse? _course;

  ClassDetailAdminPage(this._myClass, this._course);

  @override
  State<ClassDetailAdminPage> createState() => _ClassDetailAdminPageState(_myClass, _course);
}

class _ClassDetailAdminPageState extends State<ClassDetailAdminPage> {
  MyClass? _myClass;
  ClassCourse? _course;
  _ClassDetailAdminPageState(this._myClass, this._course);
  Stream<QuerySnapshot>? _stream;
  bool _onSuccess = false;
  MyClassDetail? _myClassResult;
  @override
  void initState() {
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
                        if(!_onSuccess){
                          _onSuccess = true;
                        }

                        snapshot.data!.docs.forEach((element) {
                          _myClassResult = MyClassDetail.fromJson(element.data());
                        });
                        print(_myClassResult);
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
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailProductPage(_myClass, _course))),
        child: Icon(_onSuccess?Icons.edit:Icons.add, color: CommonColor.white,),
      ),
    );
  }

  Widget _itemLession(Lession lession){
    return Container(
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
          Expanded(child: CustomText('content', textStyle: TextStyle(fontSize: 14, color: CommonColor.blue))),
          Icon(Icons.access_time_filled, color: CommonColor.blue,),
          SizedBox(width: 8,),
        ],
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
