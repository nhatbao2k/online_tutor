import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/common/menu_strip.dart';
import 'package:online_tutor/common/view_image_list.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/social/news/news_detail_page.dart';
import 'package:online_tutor/module/social/news/presenter/news_presenter.dart';
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
  Stream<DocumentSnapshot>? _streamUser;
  String _username = '';
  NewsPresenter? _presenter;
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('news').orderBy('timestamp',descending: true).snapshots();
    _presenter = NewsPresenter();
    getUserInfor();
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
                        return Wrap(
                          children: snapshot.data!.docs.map((e) {
                            Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                            return _itemNews(data);
                          }).toList(),
                        );
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
    return StreamBuilder<DocumentSnapshot>(
      stream: _streamUser,
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return SizedBox();
        }else if(snapshot.hasError){
          return SizedBox();
        } else if(!snapshot.hasData){
          return SizedBox();
        }else{
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          print(data);
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
                    child: ImageLoad.imageNetwork(data['avatar']!=null?data['avatar']:'', 50, 50),
                  ),
                  SizedBox(width: 8.0,),
                  Expanded(
                    child: CustomText(Languages.of(context).uNeed, textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
                  ),
                  IconButton(
                    onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>PostPage('',null))),
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
      },
    );
  }

  Widget _itemNews(Map<String, dynamic> data){
    List<dynamic> listImage = data['mediaUrl'];
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
                child: ImageLoad.imageNetwork(data['userAvatar']!=null?data['userAvatar']:'', 50, 50),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(data['fullname']!=null?data['fullname']:'', textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: CommonColor.black)),
                    CustomText(data['timestamp']!=null?readTimestamp(data['timestamp']):'', textStyle: TextStyle(fontSize: 12, color: CommonColor.black_light)),
                  ],
                ),
              ),
              data['username']!=null && data['username'] == _username
                  ?PopupMenuButton<MenuStrip>(
                itemBuilder: (context)=>[
                  PopupMenuItem(
                    child: CustomText(
                        Languages.of(context).edit,
                        textStyle: TextStyle(fontSize: 12)
                    ),
                    value: MenuStrip.UPDATE,
                  ),
                  PopupMenuItem(
                    child: CustomText(
                        Languages.of(context).delete,
                        textStyle: TextStyle(fontSize: 12)
                    ),
                    value: MenuStrip.DELETE,
                  ),
                ],
                onSelected: (value){
                  switch(value){
                    case MenuStrip.UPDATE:
                      Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PostPage(CommonKey.EDIT, data)));
                      break;
                    case MenuStrip.DELETE:
                      _presenter!.DeleteNews(data['id']);
                      break;
                  }
                },
                icon: Icon(
                  Icons.more_vert_sharp,
                  color: CommonColor.blue,
                ),
              )
                  :IconButton(
                icon: Icon(
                  Icons.chat_outlined,
                  color: CommonColor.blue,
                ),
                onPressed: ()=>null,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(data['description']!=null?data['description']:'', textStyle: TextStyle(color: CommonColor.black, fontSize: 14,)),
          ),
          listImage.length==1
              ? InkWell(
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewImageList(data['mediaUrl'], 0))),
                  child: ImageLoad.imageNetworkWrapContent(
                      listImage[0] != null ? listImage[0] : ''))
              :listImage.length==2?InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>NewDetailPage(data))),
                child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                ImageLoad.imageNetwork(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/2, getWidthDevice(context)/2-16),
                Spacer(),
                ImageLoad.imageNetwork(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/2, getWidthDevice(context)/2-16),
            ],
          ),
              ): InkWell(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>NewDetailPage(data))),
                child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                ImageLoad.imageNetwork(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/2, getWidthDevice(context)/2-16),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageLoad.imageNetwork(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                    SizedBox(height: 8,),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageLoad.imageNetwork(listImage[2]!=null?listImage[2]:'', getHeightDevice(context)/4-4, getWidthDevice(context)/2-16),
                        CustomText('${listImage.length>3?'+${listImage.length}':''}', textStyle: TextStyle(color: CommonColor.greyLight, fontSize: 25))
                      ],
                    ),
                  ],
                ),
            ],
          ),
              ),
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
    );
  }

  Future<void> getUserInfor() async{
    _username = await _presenter!.getUserInfor();
    _streamUser = FirebaseFirestore.instance.collection('users').doc(_username).snapshots();
    setState(()=>null);
  }
}

