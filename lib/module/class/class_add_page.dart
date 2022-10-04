import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/model/class_course.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/class/model/status.dart';
import 'package:online_tutor/module/class/presenter/class_add_presenter.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../common/common_color.dart';
import '../../common/common_key.dart';
import '../../common/common_theme.dart';
import '../../common/common_widget.dart';
import '../../res/images/image_view.dart';

class ClassAddPage extends StatefulWidget {
  ClassCourse? _course;
  String? _keyFlow;
  Map<String, dynamic>? _data;
  ClassAddPage(this._course, this._keyFlow, this._data);

  @override
  State<ClassAddPage> createState() => _ClassAddPageState(_course, _keyFlow, _data);
}

class _ClassAddPageState extends State<ClassAddPage> {
  ClassCourse? _course;
  String? _keyFlow;
  Map<String, dynamic>? _data;
  _ClassAddPageState(this._course, this._keyFlow, this._data);
  File? _fileImage;
  String _idClass=''; String _idCourse=''; String _idTeacher='';
  String _teacherName=''; String _status=''; String _startDate='';
  String _price=''; String _nameClass = ''; String _describe = '';
  List<Status> _statusList = [];
  Status? _selectStatus;
  ClassAddPresenter? _presenter;
  TextEditingController _controllerIdClass = TextEditingController();
  TextEditingController _controllerNameClass = TextEditingController();
  TextEditingController _controllerDescribeClass = TextEditingController();
  String _imageLink = '';
  @override
  void initState() {
    _idCourse = _course!.getIdCourse!;
    _idTeacher = _course!.getIdTeacher!;
    _teacherName = _course!.getNameTeacher!;
    _statusList.add(Status('', 'Trạng thái'));
    _statusList.add(Status(CommonKey.PENDING, 'Chưa bắt đầu'));
    _statusList.add(Status(CommonKey.READY, 'Bắt đầu'));
    _selectStatus = _statusList[0];
    _presenter = ClassAddPresenter();
    if(CommonKey.EDIT==_keyFlow){
      _controllerIdClass = TextEditingController(text: _data!['idClass']);
      _controllerNameClass = TextEditingController(text: _data!['nameClass']);
      _controllerDescribeClass = TextEditingController(text: _data!['describe']);
      _idClass = _data!['idClass'];
      _nameClass = _data!['nameClass'];
      _describe = _data!['describe'];
      _imageLink = _data!['imageLink'];
      for(Status s in _statusList){
        if(s.getKey==_data!['status']){
          _selectStatus = s;
        }
      }
      _status=_selectStatus!.getKey;
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
            CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).classAdd, nameFunction: Languages.of(context).createNew,callback: (value){
              if(_fileImage==null&&CommonKey.EDIT!=_keyFlow
              ){
                showToast(Languages.of(context).imageNull);
              }else if(_idClass.isEmpty){
                showToast(Languages.of(context).idClassEmpty);
              }else if(_nameClass.isEmpty){
                showToast(Languages.of(context).subjectEmpty);
              }else if(_status.isEmpty){
                showToast(Languages.of(context).statusNull);
              }else{
                MyClass myClass = MyClass(idClass: _idClass, idCourse: _idCourse, idTeacher: _idTeacher,
                  teacherName: _teacherName, status: _status, startDate: '',
                price: '', nameClass: _nameClass, describe: _describe);
                showLoaderDialog(context);
                CommonKey.EDIT!=_keyFlow?_presenter!.createClass(_fileImage!, _course!, myClass).then((value) {
                  listenStatus(context, value);
                })
                    :_fileImage!=null?_presenter!.UpdateClass(file: _fileImage, course: _course, myClass: myClass).then((value) {
                      listenStatus(context, value);
                })
                :_presenter!.UpdateClass(course: _course, myClass: myClass, url: _imageLink).then((value) {
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
                      child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):(_imageLink.isNotEmpty&&CommonKey.EDIT==_keyFlow)?ImageLoad.imageNetwork(_imageLink, 150, 150):Image.asset(ImageView.chose_image, width: 150, height: 150,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).idClass, hintText: Languages.of(context).idClass),
                        onChanged: (value)=>setState(()=> _idClass=TiengViet.parse(value)),
                        enabled: CommonKey.EDIT==_keyFlow?false:true,
                        controller: _controllerIdClass,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).nameClass, hintText: Languages.of(context).nameClass),
                        onChanged: (value)=>setState(()=> _nameClass=value),
                        controller: _controllerNameClass,
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
                            _status = _selectStatus!.getKey;
                          });
                        },
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).describeClass, hintText: Languages.of(context).describeClass),
                        onChanged: (value)=>setState(()=> _describe=value),
                        maxLines: 10,
                        controller: _controllerDescribeClass,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DropDownBoxStatus extends StatelessWidget {
  final value;
  final List<Status> itemsList;
  final Function(dynamic value) onChanged;

  const DropDownBoxStatus({
    required this.value,
    required this.itemsList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
                color: CommonColor.blue
            )
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton2(
                  isExpanded: true,
                  value: value,
                  iconEnabledColor: CommonColor.greyLight,
                  iconDisabledColor: CommonColor.greyLight,
                  items: itemsList
                      .map((Status item) => DropdownMenuItem<Status>(
                    value: item,
                    child: CustomText(
                      item.getTitle,
                      textStyle: TextStyle(fontSize: 16, color: CommonColor.black),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) => onChanged(value),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dropdownMaxHeight: MediaQuery.of(context).size.height/2,
                  dropdownWidth: MediaQuery.of(context).size.width/2+25,
                ),
              )
          ),
        ),
      ),
    );
  }
}

