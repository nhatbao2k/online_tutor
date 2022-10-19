import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/course/presenter/course_product_presenter.dart';
import 'package:online_tutor/res/images/image_view.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../common/common_color.dart';
import '../../common/common_theme.dart';
import '../teacher/model/person.dart';

class CourseProductPage extends StatefulWidget{
  String? _keyFlow;
  Map<String, dynamic>? _data;

  CourseProductPage(this._keyFlow, this._data);

  @override
  State<StatefulWidget> createState() => _CourseProductPage(_keyFlow, _data);
}

class _CourseProductPage extends State<CourseProductPage>{
  File? _fileImage;
  String _idCourse = '';
  String _nameCourse = '';
  String _idTeacher = '';
  String _teacherName = '';
  List<Person> _personListName = [];
  List<Person> _personListId = [];
  bool _loadComBox = false;
  Person? _selectName;
  Person? _selectId;
  String? _keyFlow;
  String _imageLink = '';
  TextEditingController _controllerId = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  Map<String, dynamic>? _data;

  _CourseProductPage(this._keyFlow, this._data);

  CourseProductPresenter? _presenter;

  @override
  void initState() {
    _idCourse = CommonKey.COURSE+getCurrentTime();
    _presenter = CourseProductPresenter();
    getData();
    if(CommonKey.EDIT==_keyFlow){
      _controllerName = TextEditingController(text: _data!['name']);
      _controllerId = TextEditingController(text: _data!['idCourse']);
      _nameCourse = _data!['name'];
      _idCourse = _data!['idCourse'];
      _imageLink = _data!['imageLink'];
    }
  }

  Future<void> getData() async{
   await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: CommonKey.TEACHER).get().then((value) {
      value.docs.forEach((element) {
        Person person = Person.fromJson(element.data());
        _personListName.add(person);
        _personListId.add(person);
        print(person);
      });
      _selectName = _personListName[0];
      _selectId = _personListId[0];
      _teacherName = _selectName!.fullname!;
      _idTeacher = _selectId!.phone!;
      if(CommonKey.EDIT==_keyFlow){
        for(Person p in _personListName){
          if(p.fullname==_data!['teacherName']){
            _selectName = p;
          }
        }
        for(Person p in _personListId){
          if(p.fullname==_data!['teacherName']){
            _selectId = p;
          }
        }
      }
      setState((){_loadComBox = true;});
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
            CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).createCourse, nameFunction: Languages.of(context).createNew, callback: (value){
              if(_nameCourse.isEmpty){
                showToast(Languages.of(context).nameCourseEmpty);
              }else if(_fileImage==null && CommonKey.EDIT!=_keyFlow){
                showToast(Languages.of(context).imageNull);
              } else{
                showLoaderDialog(context);
                CommonKey.EDIT!=_keyFlow?_presenter!.addCourse(_fileImage!, replaceSpace(_idCourse), _nameCourse, _teacherName, _idTeacher).then((value) {
                  _onResult(value);
                }):_fileImage!=null?_presenter!.updateCourse(fileImage: _fileImage, idCourse: replaceSpace(_idCourse), idTeacher: _idTeacher, nameCourse: _nameCourse, nameTeacher: _teacherName).then((value) {
                 _onResult(value);
                })
                :_presenter!.updateCourse(idCourse: replaceSpace(_idCourse), idTeacher: _idTeacher, nameCourse: _nameCourse, nameTeacher: _teacherName, imageLink: _imageLink).then((value) {
                  _onResult(value);
                });
              }
            },),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => cropImage((p0) => setState(()=>_fileImage=p0!), '', context),
                      child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):_imageLink.isEmpty?Image.asset(ImageView.chose_image, width: 150, height: 150,):ImageLoad.imageNetwork(_imageLink, 150, 150)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                          decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).nameCourse, hintText: Languages.of(context).nameCourse),
                          onChanged: (value)=>setState(()=> _nameCourse=value),
                        controller: _controllerName,
                      ),
                    ),
                    _loadComBox?Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomDowDownName(
                        value: _selectName,
                        itemsList: _personListName,
                        onChanged: (value){
                          setState((){
                            _selectName=value;
                            _selectId=value;
                            _teacherName=_selectName!.fullname!;
                            _idTeacher=_selectId!.phone!;
                          });
                        },
                      ),
                    ):SizedBox(),
                    _loadComBox?Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomDowDownId(
                        value: _selectId,
                        itemsList: _personListId,
                        onChanged: (value){
                          setState((){
                            _selectId=value;
                            _selectName=value;
                            _idTeacher=_selectId!.phone!;
                            _teacherName=_selectName!.fullname!;
                          });
                        },
                      ),
                    ):SizedBox()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onResult(bool value){
    Navigator.pop(context);
    if(value){
      Navigator.pop(context);
      showToast(Languages.of(context).onSuccess);
    }else{
      CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).addFailure);
    }
  }
}

class CustomDowDownName extends StatelessWidget{
  final value;
  final List<Person> itemsList;
  final Function(dynamic value) onChanged;

  const CustomDowDownName({
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
                      .map((Person item) => DropdownMenuItem<Person>(
                    value: item,
                    child: CustomText(
                      item.fullname!,
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

class CustomDowDownId extends StatelessWidget{
  final value;
  final List<Person> itemsList;
  final Function(dynamic value) onChanged;

  const CustomDowDownId({
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
                      .map((Person item) => DropdownMenuItem<Person>(
                    value: item,
                    child: CustomText(
                      item.phone!,
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