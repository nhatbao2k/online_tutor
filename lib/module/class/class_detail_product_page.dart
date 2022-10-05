import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/class/model/my_class_detail.dart';
import 'package:online_tutor/module/class/presenter/class_detail_product_presenter.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../common/common_key.dart';
import '../../common/common_theme.dart';
import '../../common/common_widget.dart';
import '../../common/drop_down_status.dart';
import '../../res/images/image_view.dart';
import 'model/Lession.dart';
import 'model/class_course.dart';
import 'model/status.dart';

class ClassDetailProductPage extends StatefulWidget {
  MyClass? _myClass;
  ClassCourse? _course;
  ClassDetailProductPage(this._myClass, this._course);

  @override
  State<ClassDetailProductPage> createState() => _ClassDetailProductPageState(_myClass, _course);
}

class _ClassDetailProductPageState extends State<ClassDetailProductPage> {
  MyClass? _myClass;
  ClassCourse? _course;
  _ClassDetailProductPageState(this._myClass, this._course);

  String _idClassDetail = ''; String _idClass = ''; String _teacherName = '';
  String _imageLink = ''; String _nameClass = ''; String _describe = '';
  List<Lession> _lessionList = [];
  File? _fileImage;
  final List<Status> _statusList = [];
  Status? _selectStatus;
  ClassDetailProductPresenter? _presenter;

  @override
  void initState() {
    _statusList.add(Status(CommonKey.PENDING, 'Chưa bắt đầu'));
    _statusList.add(Status(CommonKey.READY, 'Bắt đầu'));
    _selectStatus = _statusList[0];
    _lessionList.add(Lession(status: CommonKey.PENDING));
    _nameClass = _myClass!.nameClass!;
    _presenter = ClassDetailProductPresenter();
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
          CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).classDetailNew, nameFunction: Languages.of(context).createNew, callback: (value){
            if(_fileImage==null){
              showToast(Languages.of(context).imageNull);
            }else if(_idClassDetail.isEmpty){
              showToast(Languages.of(context).nameClassEmpty);
            }else{
              showLoaderDialog(context);
              MyClassDetail myClassDetail = MyClassDetail(idClassDetail: replaceSpace(_idClassDetail), idClass: _myClass!.idClass,
                teacherName: _myClass!.teacherName, nameClass: _nameClass,
              describe: _describe, lession: _lessionList);
              _presenter!.createClassDetail(_fileImage!, myClassDetail, _course!, _myClass!).then((value){
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
                    onTap: () => cropImage((p0) => setState(()=>_fileImage=p0!), '', context),
                    child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):Image.asset(ImageView.chose_image, width: 150, height: 150,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).idClassDetail, hintText: Languages.of(context).idClassDetail),
                      onChanged: (value)=>setState(()=> _idClassDetail=TiengViet.parse(value)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).describeClass, hintText: Languages.of(context).describeClass),
                      onChanged: (value)=>setState(()=> _describe=value),
                      maxLines: 10,
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _lessionList.length,
                    itemBuilder: (context, index) => _itemLession(_lessionList[index]),
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
    );
  }
  
  Widget _itemLession(Lession lession){
    lession.idClassDetail = _idClassDetail;
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).idLession, hintText: Languages.of(context).idLession),
              onChanged: (value)=>setState(()=> lession.lessionId=TiengViet.parse(value)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).nameLession, hintText: Languages.of(context).nameLession),
              onChanged: (value)=>setState(()=> lession.nameLession=TiengViet.parse(value)),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownBoxStatus(
                value: _selectStatus,
                itemsList: _statusList,
                onChanged: (value){
                  setState((){
                    _selectStatus = value;
                    lession.status = _selectStatus!.getKey;
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
