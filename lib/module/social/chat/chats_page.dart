import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/social/chat/chat_user_page.dart';

class ChatsPage extends StatefulWidget {
  Map<String, dynamic>? _dataUser;

  ChatsPage(this._dataUser);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

  Stream<QuerySnapshot>? _streamChat;

  @override
  void initState() {
    _streamChat = FirebaseFirestore.instance.collection('user_chat').doc(widget._dataUser!['phone']).collection(widget._dataUser!['phone']).snapshots();
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
          CustomAppBar(appType: AppType.child, title: Languages.of(context).listChat),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamChat,
              builder: (context, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return LoadingView();
                }else if(snapshot.hasError){
                  return NoDataView(Languages.of(context).noData);
                }else if(!snapshot.hasData){
                  return NoDataView(Languages.of(context).noData);
                }else{

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: snapshot.data!.docs.map((element){
                        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
                        print(data);
                        return _itemChatList(data);
                      }).toList(),
                    )
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _itemChatList(Map<String, dynamic> data){
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatUserPage(widget._dataUser!, data))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipOval(
                    child: ImageLoad.imageNetwork(data['userAvatar']!=null?data['userAvatar']:'', getWidthDevice(context)*0.15, getWidthDevice(context)*0.15),
                  ),
                  Positioned(
                    top: 2,
                    right: 0,
                    child: Container(
                      width: getWidthDevice(context)*0.03,
                      height: getWidthDevice(context)*0.03,
                      decoration: BoxDecoration(
                          color: data['isOnline']==true?CommonColor.green:CommonColor.grey,
                          shape: BoxShape.circle
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(width: 8.0,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(data['fullname']!=null?data['fullname']:'user', textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CommonColor.black)),
                    SizedBox(height: 8,),
                    CustomText(readTimestamp(data['timestamp']), textStyle: TextStyle(fontSize: 12, color: CommonColor.gray))
                  ],
                ),
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
