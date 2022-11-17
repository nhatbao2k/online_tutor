import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/module/social/chat/model/user_chat.dart';
import 'package:online_tutor/module/social/chat/presenter/chat_user_presenter.dart';

import '../../../common/common_theme.dart';
import 'dart:math' as math;

import '../../../common/view_image_list.dart';
class ChatUserPage extends StatefulWidget {
  Map<String, dynamic>? _dataUser;
  Map<String, dynamic>? _dataUserFriend;

  ChatUserPage(this._dataUser, this._dataUserFriend);

  @override
  State<ChatUserPage> createState() => _ChatUserPageState();
}

class _ChatUserPageState extends State<ChatUserPage> {
  File? _fileImage;
  ChatUserPresenter? _presenter;
  String _message='';
  TextEditingController _controllerMess = TextEditingController();
  Stream<QuerySnapshot>? _stream;
  bool _createUserChat = false;
  @override
  void initState() {
    _presenter=ChatUserPresenter();
    _stream = FirebaseFirestore.instance.collection('chats').doc(widget._dataUser!['phone']).collection(widget._dataUserFriend!['username']).snapshots();
    _checkCreateUser();
  }
  
  void _checkCreateUser(){
    FirebaseFirestore.instance.collection('user_chat').doc(widget._dataUser!['phone']).collection(widget._dataUser!['phone']).doc(widget._dataUserFriend!['username']).get().then((value) {
      if(!value.exists){
        _createUserChat = true;
        setState(()=>null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: CommonColor.blue,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(appType: AppType.child, title: widget._dataUserFriend!['fullname']),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _stream,
                  builder: (_, snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return LoadingView();
                    }else if(snapshot.hasError){
                      return SizedBox();
                    }else if(!snapshot.hasData){
                      return SizedBox();
                    }else{
                      return ListView(
                        children: snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                          return _itemChat(data);
                        }).toList(),
                      );
                    }
                  },
                )
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8,),
              padding: EdgeInsets.only(top: 8, bottom: 8),
              decoration: BoxDecoration(
                  color: CommonColor.grayLight
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _fileImage!=null?Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image(image: FileImage(_fileImage!), width: getWidthDevice(context)*0.3, height: getWidthDevice(context)*0.3,),
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: CommonColor.redAccent,
                        ),
                        onPressed: ()=>setState(()=>_fileImage=null),
                      )
                    ],
                  ):SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: 4,),
                      IconButton(
                        onPressed: ()=>cropImage(context, (p0) => setState(()=> _fileImage=p0!), ''),
                        icon: Icon(
                          Icons.image,
                          color: CommonColor.blue,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: CommonTheme.textFieldInputDecorationChat(),
                          onChanged: (value)=>setState(()=>_message=value),
                          controller: _controllerMess,
                        ),
                      ),
                      Transform.rotate(
                        angle: -35*math.pi /180,
                        child: IconButton(
                          onPressed: ()async{
                            if(_createUserChat){
                              UserChat user = UserChat(username: widget._dataUser!['phone'], fullname: widget._dataUser!['fullname'], userAvatar: widget._dataUser!['avatar'], timestamp: getTimestamp(), isOnline: true);
                              UserChat userFriend = UserChat(username: widget._dataUserFriend!['username'], fullname: widget._dataUserFriend!['fullname'], userAvatar: widget._dataUserFriend!['userAvatar'], timestamp: getTimestamp(), isOnline: true);
                              _presenter!.CreateUserChat(user, userFriend);
                              _createUserChat=false;
                            }
                            _presenter!.CreateChat(message: _message, user: widget._dataUser!, userFriend: widget._dataUserFriend!, fileImage: _fileImage);
                            _message='';
                            _fileImage=null;
                            _controllerMess = TextEditingController(text: _message);
                            hideKeyboard();
                            setState(()=>null);
                          },
                          icon: Icon(
                            Icons.send,
                            color: CommonColor.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemChat(Map<String, dynamic> data){
    List<dynamic> listImage = [];
    listImage.add(data['linkImage']);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget._dataUser!['phone']==data['username']?SizedBox():ClipOval(
              child: ImageLoad.imageNetwork(data['avatar']!=null?data['avatar']:"", getWidthDevice(context)*0.1, getWidthDevice(context)*0.1),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  data['linkImage'].toString().isEmpty?SizedBox():Align(
                    alignment:  widget._dataUser!['phone']==data['username']?Alignment.bottomRight:Alignment.bottomLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: InkWell(
    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewImageList(listImage, 0))),
    child: ImageLoad.imageNetwork(data['linkImage'], getHeightDevice(context)*0.3, getWidthDevice(context)*0.6)),
                    ),
                  ),
                  SizedBox(height: 8,),
                  data['message'].toString().isNotEmpty?Align(
                    alignment:  widget._dataUser!['phone']==data['username']?Alignment.bottomRight:Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
                     margin: EdgeInsets.only(right: 8),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(16)),
                       color: CommonColor.white,
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey.withOpacity(0.5),
                           spreadRadius: 1,
                           blurRadius: 1,
                           offset: Offset(0, 1),
                         )
                       ]
                     ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget._dataUser!['phone']==data['username']?SizedBox():CustomText(data['fullname'], textStyle: TextStyle(fontSize: 12, color: CommonColor.blue)),
                          widget._dataUser!['phone']==data['username']?SizedBox():SizedBox(height: 10,),
                          CustomText(data['message'], textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
                          SizedBox(height: 8,),
                          CustomText(readTimestamp(data['timestamp']), textStyle: TextStyle(fontSize: 10, color: CommonColor.grey)),
                        ],
                      ),
                    ),
                  ):SizedBox()
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16,)
      ],
    );
  }
}
