
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:online_tutor/common/common_api.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_theme.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';

import '../../common/common_color.dart';
import 'account_detail_presenter.dart';


class AccountDetailPage extends StatefulWidget{
  Map<String, dynamic>? _user;

  AccountDetailPage(this._user);

  @override
  State<StatefulWidget> createState() => _AccountDetailPage(_user);
}

class _AccountDetailPage extends State<AccountDetailPage>{
  Map<String, dynamic>? _user;
  String _userName = '';
  Stream<DocumentSnapshot>? _stream;
  TextEditingController? _controllerName = TextEditingController();
  TextEditingController? _controllerAddress = TextEditingController();
  TextEditingController? _controllerBirthday = TextEditingController();
  TextEditingController? _controllerDescribeInfo = TextEditingController();
  AccountDetailPresenter? _presenter;
  String _fullname = '';
  String _keyUser ='';
  String _address = '';
  String _birthday='';
  String _describeInfo='';
  String _office='';
  bool _loadFirst = true;
  File? _fileImage;

  _AccountDetailPage(this._user);


  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('users').doc(_user!['phone']).snapshots();
    _presenter = AccountDetailPresenter();
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
        onTap: () => hideKeyboard(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).accountInfo, nameFunction: Languages.of(context).save,callback: (value){
              showLoaderDialog(context);
              if(_presenter!.updateProfile(_keyUser, _fullname, _address, _birthday, _describeInfo, _office)){
               Navigator.pop(context);
               Navigator.pop(context);
              }else{
                Navigator.pop(context);
              }
            }),
            Expanded(child: SingleChildScrollView(
              child: StreamBuilder<DocumentSnapshot>(
                stream: _stream!,
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return LoadingView();
                  }
                  if(snapshot.hasError){
                    return NoDataView(Languages.of(context).noData,);
                  }
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  print(data);
                  return _itemView(data);
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _itemView(Map<String, dynamic> data) {
    if(_loadFirst){
      _keyUser = data['phone'];
      _fullname = data['fullname'];
      _controllerName = TextEditingController(text: '${data['fullname']}');
      _loadFirst=false;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CommonColor.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
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
                          onTap: ()=>cropImage(context,(p0) => setState((){
                            _fileImage=p0;
                            _presenter!.updateAvatar(p0!, _keyUser, CommonKey.AVATAR);
                          }), ''),
                          child:  ClipOval(
                            child: ImageLoad.imageNetwork(data['avatar'], 100, 100)
                          ),
                        )
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
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
                                cropImage(context,(p0) => setState(()=>_fileImage=p0), CommonKey.CAMERA);
                              },
                            ),
                          ),
                        ))
                  ]
              ),
              SizedBox(width: 8,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText('${Languages.of(context).hello}, ${data['fullname']}', textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
                    SizedBox(height: 4,),
                    CustomText('${data['email']}', textStyle: TextStyle(color: CommonColor.black, fontSize: 12))
                  ],
                ),
              ),
              IconButton(
                onPressed: ()=>null,
                icon: Icon(
                  Icons.edit,
                  color: CommonColor.blue,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16,),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: TextFormField(
            decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).fullName, hintText: Languages.of(context).fullName),
            controller: _controllerName,
            maxLines: 1,
            onChanged: (value)=>setState((){
              _fullname=value;
            }),
          ),
        ),
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            decoration: CommonTheme.textFieldInputDecoration(hintText: Languages.of(context).address, labelText: Languages.of(context).address),
            maxLines: 1,
              onChanged: (value)=>setState(()=> _address=value)
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: InkWell(
            onTap: ()=>DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(2000, 1, 31),
                maxTime: DateTime(2022, 12, 31), onChanged: (date) {
                }, onConfirm: (date) {
                  print('confirm $date');
                  _controllerBirthday = TextEditingController(text: splitSpace(date.toString()));
                  _birthday=splitSpace(date.toString());
                  setState((){});
                }, currentTime: DateTime.now(), locale: LocaleType.vi),
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
            decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).describeInfo, hintText: Languages.of(context).describeInfo),
            maxLines: 10,
              onChanged: (value)=>setState(()=> _describeInfo=value)
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).office, hintText: Languages.of(context).office),
            maxLines: 2,
              onChanged: (value)=>setState(()=> _office=value)
          ),
        )
      ],
    );
  }
}