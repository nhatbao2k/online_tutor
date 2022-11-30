import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/social/comment_news/model/comment.dart';
import 'package:online_tutor/module/social/comment_news/presenter/comment_presenter.dart';

import '../../../common/common_color.dart';
import '../../../common/common_function.dart';
import '../../../common/common_theme.dart';
import '../../../common/image_load.dart';
import '../../../common/view_image_list.dart';
import '../news/news_detail_page.dart';
import 'dart:math' as math;
class CommentNewsPage extends StatefulWidget {
  Map<String, dynamic>? _data;
  Map<String, dynamic>? _dataUser;
  CommentNewsPage(this._data, this._dataUser);

  @override
  State<CommentNewsPage> createState() => _CommentNewsPageState();
}

class _CommentNewsPageState extends State<CommentNewsPage> {

  Stream<DocumentSnapshot>? _streamNew;
  Stream<QuerySnapshot>? _streamComment;
  String _message = '';
  TextEditingController _controllerMess = TextEditingController();
  File? _fileImage;
  String _nameFeedback = '';
  bool _isFeedback = false;
  CommentPresenter? _presenter;
  String _level = '1';
  Comment? _comment;
  int _indexLevel = 0;
  String _linkImage = '';
  @override
  void initState() {
    _presenter = CommentPresenter();
    _streamNew = FirebaseFirestore.instance.collection('news').doc(widget._data!['id']).snapshots();
    _streamComment = FirebaseFirestore.instance.collection('comment').doc(widget._data!['id']).collection(widget._data!['id']).orderBy('timeStamp', descending: false).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(appType: AppType.child, title: widget._data!['description']),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: _streamNew,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return LoadingView();
                      }else if(snapshot.hasError){
                        return NoDataView(Languages.of(context).noData);
                      }else if(!snapshot.hasData){
                        return NoDataView(Languages.of(context).noData);
                      }else{
                        Map<String, dynamic> data = snapshot.data!.data() as  Map<String, dynamic>;
                        List<dynamic> listImage = data['mediaUrl'];
                        return Container(
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
                                    ImageLoad.imageNetwork(listImage[0]!=null?listImage[0]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
                                    Spacer(),
                                    ImageLoad.imageNetwork(listImage[1]!=null?listImage[1]:'', getHeightDevice(context)/4, getWidthDevice(context)/2-16),
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
                              SizedBox(height: 8,),
                              Divider(thickness: 2),
                              SizedBox(height: 8,),
                              StreamBuilder<QuerySnapshot>(
                                stream: _streamComment,
                                builder: (context, snapshotsComment){
                                  if(snapshotsComment.connectionState==ConnectionState.waiting){
                                    return LoadingView();
                                  }else if(snapshotsComment.hasError){
                                    return NoDataView(Languages.of(context).noData);
                                  }else if(!snapshotsComment.hasData){
                                    return NoDataView(Languages.of(context).noData);
                                  }else{
                                    return ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: snapshotsComment.data!.docs.map((e) {
                                        Map<String, dynamic> dataComment = e.data() as Map<String, dynamic>;
                                        Comment comment = Comment.fromJson(e.data());
                                        print('$dataComment, \n$comment');
                                        return _itemChat(comment);
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 100,)
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
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
                            if(_message.isNotEmpty||_fileImage!=null){

                              Comment? comment = await _level!='1'
                                  ?_comment
                                  :Comment(
                                  nameFeedback: _nameFeedback,
                                  name: widget._dataUser!['fullname'],
                                  content: _message,
                                  idUser: widget._dataUser!['phone'],
                                  avatar: widget._dataUser!['avatar'],
                                  timeStamp: getTimestamp(),
                                  level: _level,
                                  listComment: [
                                  ]
                              );
                              if(_level!='1'&&_fileImage!=null){
                                _linkImage = await _presenter!.getLinkImage(idNews: widget._data!['id'], comment: comment!, imageFile: _fileImage!);
                              }
                              _level=='2'?_comment!.listComment!.add(
                                  Comment(
                                      id: getCurrentTime(),
                                      nameFeedback: _nameFeedback,
                                      name: widget._dataUser!['fullname'],
                                      content: replaceKey(_message, _nameFeedback),
                                      idUser: widget._dataUser!['phone'],
                                      avatar: widget._dataUser!['avatar'],
                                      timeStamp: getTimestamp(),
                                      level: _level,
                                      imageLink: _linkImage,
                                      listComment: [
                                      ]
                                  )
                              ):_level=='3'?_comment!.listComment![_indexLevel].listComment!.add( Comment(
                                  id: getCurrentTime(),
                                  nameFeedback: _nameFeedback,
                                  name: widget._dataUser!['fullname'],
                                  content: replaceKey(_message, _nameFeedback),
                                  idUser: widget._dataUser!['phone'],
                                  avatar: widget._dataUser!['avatar'],
                                  timeStamp: getTimestamp(),
                                  imageLink: _linkImage,
                                  level: _level,
                              )):null;
                              _fileImage!=null
                                  ?_presenter!.SendChat(idNews: widget._data!['id'], comment: comment!, type: _level!='1'?CommonKey.UPDATE_CHILD:CommonKey.ADD_NEW, imageFile: _fileImage!)
                                  :_presenter!.SendChat(idNews: widget._data!['id'], comment: comment!, type: _level!='1'?CommonKey.UPDATE_CHILD:CommonKey.ADD_NEW);
                              _message = '';
                              _fileImage = null;
                              _controllerMess = TextEditingController(text: _message);
                              _isFeedback = false;
                              _nameFeedback = '';
                              _comment=null;
                              hideKeyboard();
                              setState(()=>null);
                            }
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
            ),
          )
        ],
      ),
    );
  }

  Widget _itemChat(Comment comment){
    List<dynamic> image =[comment.imageLink];
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: ImageLoad.imageNetwork(comment.avatar, 40, 40),
            ),
            SizedBox(width: 8,),
            SizedBox(
              width: getWidthDevice(context)/1.5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(comment.name!, textStyle: TextStyle(fontSize: 14, color: CommonColor.gray,)),
                  (comment.nameFeedback==null||comment.nameFeedback!.isEmpty)?SizedBox():CustomText(comment.nameFeedback!, textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CommonColor.black)),
                  CustomText(comment.content!, textStyle: TextStyle(fontSize: 14, color: CommonColor.black,))
                ],
              ),
            ),
          ],
        ),
        comment.imageLink!=null&&comment.imageLink!.isNotEmpty
            ?Padding(
          padding: const EdgeInsets.only(left: 50, top: 8),
          child: InkWell(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewImageList(image, 0))),
              child: ImageLoad.imageNetwork(comment.imageLink, getWidthDevice(context)*0.5, getWidthDevice(context)*0.5)),
        )
            :SizedBox(),
        SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 48,),
            InkWell(
              onTap: (){
                setState((){
                  _isFeedback = true;
                  _nameFeedback = '${comment.name}';
                  _controllerMess = TextEditingController(text: _nameFeedback);
                  _level='2';
                  _comment = Comment(
                    nameFeedback: comment.nameFeedback,
                    name: comment.name,
                    content: comment.content,
                    idUser: comment.idUser,
                    avatar: comment.avatar,
                    timeStamp: comment.timeStamp,
                    level: comment.level,
                    imageLink: comment.imageLink,
                    listComment: comment.listComment,
                    id: comment.id
                  );
                });
              },
              child: CustomText(
                  Languages.of(context).feedback,
                  textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
              ),
            ),
            SizedBox(width: 50,),
            widget._dataUser!['phone']==comment.idUser?InkWell(
              onTap: (){
                _presenter!.DeleteComment(comment,widget._data!['id']);
              },
              child: CustomText(
                  Languages.of(context).delete,
                  textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
              ),
            ):SizedBox(),
          ],
        ),
        comment.listComment!.length>0?Wrap(
          children: List.generate(comment.listComment!.length, (index) => _itemChatChild(comment.listComment![index], index, comment)).toList(),
        ):SizedBox()
      ],
    );
  }

  Widget _itemChatChild(Comment comment, int index, Comment commentParent){
    List<dynamic> image =[comment.imageLink];
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: ImageLoad.imageNetwork(comment.avatar, 35, 35),
              ),
              SizedBox(width: 8,),
              SizedBox(
                width: getWidthDevice(context)/1.5,
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
                        CustomText(comment.name!, textStyle: TextStyle(fontSize: 15, color: CommonColor.black,fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxline: 1),
                        SizedBox(width: 4,),
                        Expanded(child:(comment.nameFeedback==null||comment.nameFeedback!.isEmpty)?SizedBox():CustomText('@${comment.nameFeedback!}', textStyle: TextStyle(fontSize: 15,  color: CommonColor.gray, overflow: TextOverflow.ellipsis), maxline: 1),
                        )
                      ],
                    ),
                    SizedBox(height: 4,),
                    CustomText(comment.content!, textStyle: TextStyle(fontSize: 15, color: CommonColor.black,))
                  ],
                ),
              ),
            ],
          ),
          comment.imageLink!=null&&comment.imageLink!.isNotEmpty
              ?Padding(
            padding: const EdgeInsets.only(left: 50, top: 8),
            child: InkWell(
                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewImageList(image, 0))),
                child: ImageLoad.imageNetwork(comment.imageLink, getWidthDevice(context)*0.5, getWidthDevice(context)*0.5)),
          )
              :SizedBox(),
          SizedBox(height: 12,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 48,),
              InkWell(
                onTap: (){
                  setState((){
                    _isFeedback = true;
                    _nameFeedback = '${comment.name}';
                    if(comment.level=='2'){
                      _indexLevel = index;
                    }
                    _controllerMess = TextEditingController(text: _nameFeedback);
                    _level='3';
                    _comment = commentParent;
                    print(commentParent);
                  });
                },
                child: CustomText(
                    Languages.of(context).feedback,
                    textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
                ),
              ),
              SizedBox(width: 50,),
              widget._dataUser!['phone']==comment.idUser?InkWell(
                onTap: (){
                  if(comment.level=="2"){
                    commentParent.listComment!.remove(comment);
                  }else{
                    commentParent.listComment![index].listComment!.remove(comment);
                  }
                  _presenter!.UpdateChildComment(commentParent, widget._data!['id']);
                },
                child: CustomText(
                    Languages.of(context).delete,
                    textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
                ),
              ):SizedBox(),
            ],
          ),
          (comment.listComment!=null)?Wrap(
            children: List.generate(comment.listComment!.length, (index3) => _itemChatChild(comment.listComment![index3], index, commentParent)).toList(),
          ):SizedBox()
        ],
      ),
    );
  }
}
