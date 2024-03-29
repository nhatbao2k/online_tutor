
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/teacher/presenter/teacher_add_presenter.dart';

import '../../common/common_color.dart';
import '../../common/common_function.dart';
import '../../common/common_key.dart';
import '../../common/common_theme.dart';
import '../../common/common_widget.dart';
import '../../res/images/image_view.dart';

class TeacherAddPage extends StatefulWidget {
  Map<String, dynamic>? _data;
  String? _role;
  TeacherAddPage(this._data, this._role);

  @override
  State<TeacherAddPage> createState() => _TeacherAddPageState();
}

class _TeacherAddPageState extends State<TeacherAddPage> {
  String _userName = '';
  TextEditingController? _controllerName = TextEditingController();
  TextEditingController? _controllerAddress = TextEditingController();
  TextEditingController? _controllerBirthday = TextEditingController();
  TextEditingController? _controllerDescribeInfo = TextEditingController();
  TextEditingController? _controllerPhone = TextEditingController();
  TextEditingController? _controllerEmail = TextEditingController();
  String _fullname = '';
  String _keyUser ='';
  String _address = '';
  String _birthday='';
  String _describeInfo='';
  String _office='';
  String _phone ='';
  String _email='';
  bool _loadFirst = true;
  File? _fileImage;
  String _avatar = '';
  TeacherAddPresenter? _presenter;



  @override
  void initState() {
    _presenter = TeacherAddPresenter();
    if(widget._data!=null){
      _avatar = widget._data!['avatar'];
      _userName = widget._data!['phone'];
      _fullname = widget._data!['fullname'];
      _phone = widget._data!['phone'];
      _controllerPhone = TextEditingController(text:widget._data!['phone']);
      _controllerName = TextEditingController(text: widget._data!['fullname']);
      _address = widget._data!['address'];
      _controllerAddress = TextEditingController(text: widget._data!['address']);
      _describeInfo = widget._data!['describe'];
      _birthday = widget._data!['birthday'];
      _controllerBirthday = TextEditingController(text: widget._data!['birthday']);
      _office = widget._data!['office'];
      _controllerDescribeInfo = TextEditingController(text: widget._data!['describe']);
      _describeInfo = widget._data!['describe'];
      _email = widget._data!['email'];
      _controllerEmail = TextEditingController(text: _email);
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
        onTap: ()=> hideKeyboard(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonKey.ADMIN==widget._role?CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).teacherAdd, nameFunction: Languages.of(context).createNew, callback: (value){
              showLoaderDialog(context);
              if(widget._data==null&&CommonKey.ADMIN==widget._role){
                _fileImage!=null?_presenter!.createAccount(file: _fileImage!,name: _fullname, phone: _phone, email: _email, address: _address, birthday: _birthday, describe: _describeInfo).then((value) {
                  Navigator.pop(context);
                  if(value){
                    Navigator.pop(context);
                  }else{
                    CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).addFailure);
                  }
                }):_presenter!.createAccount(name: _fullname,phone:  _phone,email:  _email,address:  _address,birthday:  _birthday,describe:  _describeInfo).then((value) {
                  Navigator.pop(context);
                  if(value){
                    Navigator.pop(context);
                    showToast(Languages.of(context).onSuccess);
                  }else{
                    CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).addFailure);
                  }
                });
              }else{
                _presenter!.updateTeacher(_fileImage, _fullname, _phone, _address, _birthday, _describeInfo, _keyUser, _avatar).then((value) {
                  Navigator.pop(context);
                  if(value){
                    Navigator.pop(context);
                    showToast(Languages.of(context).onSuccess);
                  }else{
                    CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).onFailure);
                  }
                });
              }

            },)
                :
            CustomAppBar(appType: AppType.child, title: Languages.of(context).teacher),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                        children:[
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                                  border: Border.all(
                                      color: CommonColor.orangeOriginLight,
                                      width: 1.0
                                  )
                              ),
                              child: InkWell(
                                onTap: (){
                                  if(CommonKey.ADMIN==widget._role){
                                    cropImage(context, (p0) => setState((){
                                      _fileImage=p0;
                                    }), '');
                                  }

                                },
                                child:  ClipOval(
                                    child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):_avatar.isNotEmpty&&widget._data!=null
                                        ?Image.network(_avatar,width: 150, height: 150,fit: BoxFit.cover,)
                                        :Image.asset(ImageView.no_load, width: 150, height: 150, fit: BoxFit.cover,)
                                ),
                              )
                          ),
                          CommonKey.ADMIN==widget._role?Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(200)),
                                    color: CommonColor.white,
                                    border: Border.all(width: 1.0, color: CommonColor.orangeOriginLight)
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt, size: 12, color: CommonColor.grey,),
                                    onPressed: (){
                                      cropImage(context, (p0) => setState(()=>_fileImage=p0), CommonKey.CAMERA);
                                    },
                                  ),
                                ),
                              )):SizedBox()
                        ]
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 16),
                      child: TextFormField(
                        decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).fullName, hintText: Languages.of(context).fullName),
                        controller: _controllerName,
                        maxLines: 1,
                        onChanged: (value)=>setState((){
                          _fullname=value;
                        }),
                        validator: (value){
                          return value!.isEmpty?Languages.of(context).nameEmpty:null;
                        },
                      ),
                    ),
                    SizedBox(height: 8,),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _controllerPhone,
                          decoration: CommonTheme.textFieldInputDecoration(hintText: Languages.of(context).phone, labelText: Languages.of(context).phone),
                          maxLines: 1,
                          onChanged: (value)=>setState(()=> _phone=value),
                        keyboardType: TextInputType.phone,
                        validator: (value){
                            return value!.isEmpty?Languages.of(context).phoneEmpty:_phone.length!=10?Languages.of(context).phoneError:null;
                        },
                        enabled: widget._data!=null?false:true,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _controllerEmail,
                          decoration: CommonTheme.textFieldInputDecoration(hintText: Languages.of(context).email, labelText: Languages.of(context).email),
                          maxLines: 1,
                          onChanged: (value)=>setState(()=> _email=value),
                        keyboardType: TextInputType.emailAddress,
                        validator:(value){
                          return value!.isEmpty?Languages.of(context).emailEmpty:!validateEmail(value)?Languages.of(context).emailError:null;
                        },
                        enabled: widget._data!=null? false: true,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _controllerAddress,
                          decoration: CommonTheme.textFieldInputDecoration(hintText: Languages.of(context).address, labelText: Languages.of(context).address),
                          maxLines: 1,
                          onChanged: (value)=>setState(()=> _address=value),
                        enabled: CommonKey.ADMIN==widget._role?true:false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                        onTap: (){
                          if(CommonKey.ADMIN==widget._role){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 31),
                                maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                  _controllerBirthday = TextEditingController(text: splitSpace(date.toString()));
                                  _birthday=splitSpace(date.toString());
                                  setState((){});
                                }, currentTime: DateTime.now(), locale: LocaleType.vi);
                          }
                        },
                        child: TextFormField(
                            decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).birthday, hintText: Languages.of(context).birthday),
                            maxLines: 1,
                            enabled: false,
                            controller: _controllerBirthday,
                            onChanged: (value)=>setState(()=> _birthday=value)
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _controllerDescribeInfo,
                          decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).describeInfo, hintText: Languages.of(context).describeInfo),
                          maxLines: 10,
                          onChanged: (value)=>setState(()=> _describeInfo=value,
                          ),
                        enabled: CommonKey.ADMIN==widget._role?true:false,
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
