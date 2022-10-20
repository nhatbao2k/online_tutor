import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/common/menu_strip.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/social/post/post_page.dart';
import 'package:online_tutor/res/images/image_view.dart';

class NewPages extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewPages();
  }

}

class _NewPages extends State<NewPages>{
  Stream<QuerySnapshot>? _stream;


  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('news').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(appType: AppType.appbar_home, title: Languages.of(context).qa),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return LoadingView();
                      }else if(snapshot.hasError){
                        return NoDataView(Languages.of(context).noData);
                      }else{
                        return ListView(
                          children: snapshot.data!.docs.map((e) {
                            Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                            return ;
                          }).toList(),
                        )
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _header(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: 8,),
            ClipOval(
              child: ImageLoad.imageNetwork('', 50, 50),
            ),
            SizedBox(width: 8.0,),
            Expanded(
              child: CustomText(Languages.of(context).uNeed, textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
            ),
            IconButton(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>PostPage())),
              icon: Icon(Icons.image, color: CommonColor.blue,),
            )
          ],
        ),
        SizedBox(height: 8,),
        Container(
          color: CommonColor.greyLight,
          width: getWidthDevice(context),
          height: getHeightDevice(context)/8,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                        'Chụp ảnh bài tập',
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                    CustomText('gửi nhanh bằng camera')
                  ],
                ),
              ),
              Image.asset(ImageView.camera_social)
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemChat(){
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 4,),
              ClipOval(
                child: ImageLoad.imageNetwork('url', 50, 50),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText('Nhật Bảo', textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: CommonColor.black)),
                    CustomText('1 tiếng trước', textStyle: TextStyle(fontSize: 12, color: CommonColor.black_light)),
                  ],
                ),
              ),
              PopupMenuButton<MenuStrip>(
                itemBuilder: (context)=>[
                  PopupMenuItem(
                    child: CustomText(
                        Languages.of(context).edit,
                        textStyle: TextStyle(fontSize: 12)
                    ),
                  ),
                  PopupMenuItem(
                    child: CustomText(
                        Languages.of(context).delete,
                        textStyle: TextStyle(fontSize: 12)
                    ),
                  ),
                ],
                onSelected: (value){
                  switch(value){
                    case MenuStrip.UPDATE:
                      showToast('sửa');
                      break;
                    case MenuStrip.DELETE:
                      showToast('xóa');
                      break;
                  }
                },
                icon: Icon(
                  Icons.more_vert_sharp,
                  color: CommonColor.blue,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText('Bài này làm như thế lào hả ae', textStyle: TextStyle(color: CommonColor.black, fontSize: 14,)),
          ),
          ImageLoad.imageNetwork('', getHeightDevice(context)/2, getWidthDevice(context)),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chat,
                  color: CommonColor.blue,
                ),
                onPressed: ()=>null,
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: CommonColor.blue,
                ),
                onPressed: ()=>null,
              )
            ],
          )
        ],
      ),
    ),;
  }
}

