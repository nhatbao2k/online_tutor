import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/drop_down_birthday.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/model/birthday.dart';
import 'package:online_tutor/module/class/model/class_course.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/class/model/status.dart';
import 'package:online_tutor/module/class/presenter/class_add_presenter.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../common/common_key.dart';
import '../../common/common_theme.dart';
import '../../common/common_widget.dart';
import '../../common/drop_down_status.dart';
import '../../res/images/image_view.dart';

class ClassAddPage extends StatefulWidget {
  final ClassCourse? _course;
  final String? _keyFlow;
  final Map<String, dynamic>? _data;
  ClassAddPage(this._course, this._keyFlow, this._data);

  @override
  State<ClassAddPage> createState() => _ClassAddPageState(_course, _keyFlow, _data);
}

class _ClassAddPageState extends State<ClassAddPage> {
  final ClassCourse? _course;
  final String? _keyFlow;
  final Map<String, dynamic>? _data;
  _ClassAddPageState(this._course, this._keyFlow, this._data);
  File? _fileImage;
  String _idClass=''; String _idCourse=''; String _idTeacher='';
  String _teacherName=''; String _status=''; final String _startDate='';
  final String _price=''; String _nameClass = ''; String _describe = '';
  final List<Status> _statusList = [];
  Status? _selectStatus;
  ClassAddPresenter? _presenter;
  TextEditingController _controllerIdClass = TextEditingController();
  TextEditingController _controllerNameClass = TextEditingController();
  TextEditingController _controllerDescribeClass = TextEditingController();
  String _imageLink = '';
  String _hour = '';
  String _day = 'MON';
  List<Birthday> _birthdayList = [
    Birthday(date: 'Thứ 2', key: CommonKey.MON),
    Birthday(date: 'Thứ 3', key: CommonKey.TUE),
    Birthday(date: 'Thứ 4', key: CommonKey.WED),
    Birthday(date: 'Thứ 5', key: CommonKey.THU),
    Birthday(date: 'Thứ 6', key: CommonKey.FRI),
    Birthday(date: 'Thứ 7', key: CommonKey.SAT),
    Birthday(date: 'Chủ Nhật', key: CommonKey.SUN),
  ];
  Birthday? _birthdaySelect;
  TextEditingController _controllerBirthday = TextEditingController();
  @override
  void initState() {
    _idClass=CommonKey.CLASS+getCurrentTime();
    _idCourse = _course!.getIdCourse!;
    _idTeacher = _course!.getIdTeacher!;
    _teacherName = _course!.getNameTeacher!;
    _statusList.add(Status('', 'Trạng thái'));
    _statusList.add(Status(CommonKey.PENDING, 'Chưa bắt đầu'));
    _statusList.add(Status(CommonKey.READY, 'Bắt đầu'));
    _selectStatus = _statusList[0];
    _birthdaySelect = _birthdayList[0];
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
      _day = _data!['startDate'];
      _hour = _data!['startHours'];
      _controllerBirthday = TextEditingController(text: _hour);
      _birthdaySelect = CommonKey.MON==_day?_birthdayList[0]
          :CommonKey.TUE==_day?_birthdayList[1]
          :CommonKey.WED==_day?_birthdayList[2]
          :CommonKey.THU==_day?_birthdayList[3]
          :CommonKey.FRI==_day?_birthdayList[4]
          :CommonKey.SAT==_day?_birthdayList[5]
          :_birthdayList[6];
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
              }else if(_nameClass.isEmpty){
                showToast(Languages.of(context).subjectEmpty);
              }else if(_status.isEmpty){
                showToast(Languages.of(context).statusNull);
              }else if(_hour.isEmpty){
                showToast(Languages.of(context).hourEmpty);
              }else{
                MyClass myClass = MyClass(idClass: replaceSpace(_idClass), idCourse: _idCourse, idTeacher: _idTeacher,
                  teacherName: _teacherName, status: _status, startDate: _day, startHour: _hour,
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
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child:InkWell(
                        onTap: ()=>DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              List list = splitList(splitSpaceEnd(date.toString()));
                              _hour = '${list[0]}:${list[1]}';
                              _controllerBirthday = TextEditingController(text: _hour);
                              setState(()=>null);
                            }, currentTime: DateTime.now(), locale: LocaleType.vi),
                        child: TextFormField(
                          decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).startHours, hintText: Languages.of(context).startHours),
                          enabled: false,
                          controller: _controllerBirthday,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: DropDownBirthday(
                        value: _birthdaySelect,
                        itemsList: _birthdayList,
                        onChanged: (value){
                          setState((){
                            _birthdaySelect=value;
                            _day=_birthdaySelect!.key!;
                          });
                        },
                      ),
                    )
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

