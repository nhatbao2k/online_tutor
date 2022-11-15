import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';

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
    _streamChat = FirebaseFirestore.instance.collection('users_chat').snapshots();
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
                    child: ListView.separated(
                        itemBuilder: (context, index)=>_itemChatList(),
                        separatorBuilder: (context, index)=>SizedBox(height: 16,),
                        itemCount: 10),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _itemChatList(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipOval(
              child: ImageLoad.imageNetwork('', getWidthDevice(context)*0.15, getWidthDevice(context)*0.15),
            ),
            Positioned(
              top: 2,
              right: 0,
              child: Container(
                width: getWidthDevice(context)*0.03,
                height: getWidthDevice(context)*0.03,
                decoration: BoxDecoration(
                  color: CommonColor.green,
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
              CustomText('user', textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CommonColor.black)),
              SizedBox(height: 8,),
              CustomText('3h trc', textStyle: TextStyle(fontSize: 12, color: CommonColor.grayLight))
            ],
          ),
        )
      ],
    );
  }
}
