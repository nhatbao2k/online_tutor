import 'dart:io';

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

  @override
  void initState() {
    _presenter=ChatUserPresenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ListView.separated(
                  itemBuilder: (context, index)=>_itemChat(),
                  separatorBuilder: (context, index)=>SizedBox(height: 16,),
                  itemCount: 10),
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
                        onChanged: (value)=>setState(()=>null),

                      ),
                    ),
                    Transform.rotate(
                      angle: -35*math.pi /180,
                      child: IconButton(
                        onPressed: ()async{
                          UserChat user = UserChat(username: widget._dataUser!['phone'], fullname: widget._dataUser!['fullname'], avatar: widget._dataUser!['avatar'], timestamp: getTimestamp(), isOnline: true);
                          UserChat userFriend = UserChat(username: widget._dataUserFriend!['username'], fullname: widget._dataUserFriend!['username'], avatar: widget._dataUserFriend!['userAvatar'], timestamp: getTimestamp(), isOnline: true);
                          _presenter!.CreateUserChat(user, userFriend);
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
    );
  }

  Widget _itemChat(/*Map<String, dynamic> data*/){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipOval(
          child: ImageLoad.imageNetwork('', getWidthDevice(context)*0.1, getWidthDevice(context)*0.1),
        ),
        SizedBox(width: 8,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: ImageLoad.imageNetwork(/*data['imageLink']*/'', getHeightDevice(context)*0.3, getWidthDevice(context)*0.6),
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.only(right: 10, left: 10, top: 8, bottom: 8),
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
                    CustomText('data[content]', textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
                    SizedBox(height: 16,),
                    CustomText('data[a3h]', textStyle: TextStyle(fontSize: 10, color: CommonColor.grey)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
