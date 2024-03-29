import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/class/model/my_class_detail.dart';
import 'package:online_tutor/module/class/presenter/class_detail_product_presenter.dart';

import '../../common/common_key.dart';
import '../../common/common_theme.dart';
import '../../common/common_widget.dart';
import '../../common/drop_down_status.dart';
import '../../res/images/image_view.dart';
import 'model/class_course.dart';
import 'model/lession.dart';
import 'model/status.dart';

class ClassDetailProductPage extends StatefulWidget {
  MyClass? _myClass;
  ClassCourse? _course;
  String? _keyFlow;
  MyClassDetail? _myClassResult;
  ClassDetailProductPage(this._myClass, this._course, this._keyFlow, this._myClassResult);

  @override
  State<ClassDetailProductPage> createState() => _ClassDetailProductPageState(_myClass, _course, _keyFlow, _myClassResult);
}

class _ClassDetailProductPageState extends State<ClassDetailProductPage> {
  MyClass? _myClass;
  ClassCourse? _course;
  String? _keyFlow;
  MyClassDetail? _myClassResult;
  _ClassDetailProductPageState(this._myClass, this._course, this._keyFlow, this._myClassResult);

  String _idClassDetail = ''; String _idClass = ''; String _teacherName = '';
  String _imageLink = ''; String _nameClass = ''; String _describe = '';
  List<Lession> _lessionList = [];
  File? _fileImage;
  final List<Status> _statusList = [];
  Status? _selectStatus;
  ClassDetailProductPresenter? _presenter;
  TextEditingController _controllerIdLession = TextEditingController();
  TextEditingController _controllerDescribe = TextEditingController();
  int _indexLength = 0;

  @override
  void initState() {
    _statusList.add(Status(CommonKey.PENDING, 'Chưa bắt đầu'));
    _statusList.add(Status(CommonKey.READY, 'Bắt đầu'));
    _selectStatus = _statusList[0];
    _lessionList.add(Lession(status: CommonKey.PENDING));
    _nameClass = _myClass!.nameClass!;
    _idClassDetail = CommonKey.CLASS_DETAIL+getCurrentTime();
    _presenter = ClassDetailProductPresenter();
    if(CommonKey.EDIT==_keyFlow){
      _controllerIdLession = TextEditingController(text: _myClassResult!.idClassDetail);
      _controllerDescribe = TextEditingController(text: _myClassResult!.describe);
      _lessionList = _myClassResult!.lession!;
      _imageLink = _myClassResult!.imageLink!;
      _idClassDetail=_myClassResult!.idClassDetail!;
      _nameClass=_myClassResult!.nameClass!;
      _indexLength = _myClassResult!.lession!.length;
      _describe = _myClassResult!.describe!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: ()=>hideKeyboard(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).classDetailNew, nameFunction: Languages.of(context).createNew, callback: (value){
              if(_fileImage==null&&CommonKey.EDIT!=_keyFlow){
                showToast(Languages.of(context).imageNull);
              }else{
                showLoaderDialog(context);
                MyClassDetail myClassDetail = MyClassDetail(idClassDetail: replaceSpace(_idClassDetail), idClass: _myClass!.idClass,
                  teacherName: _myClass!.teacherName, nameClass: _nameClass,
                describe: _describe, lession: _lessionList);
                CommonKey.EDIT!=_keyFlow?_presenter!.createClassDetail(_fileImage!, myClassDetail, _course!, _myClass!).then((value){
                  listenStatus(context, value);
                })
                    :_fileImage!=null?_presenter!.UpdateClassDetail(fileImage: _fileImage, myClass: _myClass, myClassDetail: myClassDetail, course: _course).then((value) {
                      listenStatus(context, value);
                })
                :_presenter!.UpdateClassDetail(myClass: _myClass, myClassDetail: myClassDetail, course: _course, linkImage: _imageLink).then((value) {
                  listenStatus(context, value);
                });
              }
            },),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => cropImage(context, (p0) => setState(()=>_fileImage=p0!), ''),
                      child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):(!_imageLink.isEmpty?ImageLoad.imageNetwork(_imageLink, 150, 150):Image.asset(ImageView.chose_image, width: 150, height: 150,))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).describeClass, hintText: Languages.of(context).describeClass),
                        onChanged: (value)=>setState(()=> _describe=value),
                        maxLines: 10,
                        controller: _controllerDescribe,
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _lessionList.length,
                      itemBuilder: (context, index) => _itemLession(_lessionList[index], index),
                    ),
                    SizedBox(height: 8,),
                    Center(
                      child: ButtonIcon(Icons.add, (data) => setState(()=>_lessionList.add(Lession(status: CommonKey.PENDING)))),
                    ),
                    SizedBox(height: 16,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _itemLession(Lession lession, int index){
    Status selectStatus = _selectStatus!;
    print('test $selectStatus -- ');
    if(CommonKey.EDIT!=_keyFlow){
      lession.idClassDetail = _idClassDetail;
      lession.lessionId = CommonKey.LESSION+getCurrentTime();
    }
    if(lession.lessionId==null){
      lession.lessionId = CommonKey.LESSION+getCurrentTime();
    }
    TextEditingController controllerId = TextEditingController();
    TextEditingController controllerName = TextEditingController();
    if(CommonKey.EDIT==_keyFlow){
      if(lession.idClassDetail!=null){
        controllerId = TextEditingController(text: lession.lessionId);
        controllerName = TextEditingController(text: lession.nameLession);
        for(Status t in _statusList){
          if(lession.status==t.getKey){
            selectStatus=t;
          }
        }
      }
    }
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: CommonColor.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (CommonKey.EDIT==_keyFlow&&_indexLength>index)?Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
            child: CustomText(lession.nameLession!, textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
          ):SizedBox(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).nameLession, hintText: Languages.of(context).nameLession),
              onChanged: (value)=>setState(() {
                lession.nameLession = value;
              }),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownBoxStatus(
                value: selectStatus,
                itemsList: _statusList,
                onChanged: (value){
                  setState((){
                    selectStatus = value;
                    lession.status = selectStatus.getKey;
                  });
                },
              )
          ),
          Center(child: ButtonDefault(Languages.of(context).delete, (data) => setState(()=>_lessionList.remove(lession))))
        ],
      ),
    );
  }
}
