import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_theme.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/discuss/presenter/discuss_presenter.dart';
import 'package:online_tutor/module/lession/model/discuss.dart';
import 'package:online_tutor/module/lession/model/lession_detail.dart';

import '../../../common/image_load.dart';
import 'dart:math' as math;

import '../../common/view_image_list.dart';
class DiscussPage extends StatefulWidget {

  LessionDetail? _lession;

  DiscussPage(this._lession);

  @override
  State<DiscussPage> createState() => _DiscussPageState(_lession);
}

class _DiscussPageState extends State<DiscussPage> {
  LessionDetail? _lession;

  _DiscussPageState(this._lession);

  Stream<DocumentSnapshot>? _stream;
  File? _fileImage;
  Map<String, dynamic>? _dataUser;
  DiscussPresenter? _presenter;
  LessionDetail? _detail;
  String _message = '';
  TextEditingController _controllerMess = TextEditingController();
  bool _isFeedback = false;
  String _nameFeedback = '';
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('lession_detail').doc(_lession!.idLessionDetail!).snapshots();
    _presenter = DiscussPresenter();
    getAccountInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: GestureDetector(
        onTap: () => hideKeyboard(),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _stream!,
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return LoadingView();
            }else if(snapshot.hasError){
              return NoDataView(Languages.of(context).noData);
            }else if(!snapshot.hasData){
              return NoDataView(Languages.of(context).noData);
            }else{
              dynamic data = snapshot.data!.data();
              _detail = LessionDetail.fromJson(data);
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: _detail!.discuss!.length,
                      itemBuilder: (context, index)=>_itemChat(_detail!.discuss![index], index),
                      separatorBuilder: (context, index)=>SizedBox(height: 16,),
                    ),
                  ),
                  Container(
                    color: CommonColor.white,
                    width: getWidthDevice(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _fileImage!=null
                            ?Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Image(image: FileImage(_fileImage!,), width: getWidthDevice(context)*0.2, height: getWidthDevice(context)*0.25,),
                            IconButton(
                              onPressed: ()=>setState(()=>_fileImage=null),
                              icon: Icon(
                                Icons.clear,
                                color: CommonColor.grayLight,
                              ),
                            )
                          ],
                        )
                        :SizedBox(),
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
                                onPressed: (){
                                  if(_message.isNotEmpty){
                                    Discuss discuss = Discuss(
                                      avatar: _dataUser!['avatar']!=null?_dataUser!['avatar']:'',
                                      content: replaceKey(_message, _nameFeedback),
                                      timeStamp:getTimestamp(),
                                      name: _dataUser!['fullname']!=null?_dataUser!['fullname']:'',
                                      nameFeedback: _nameFeedback
                                    );
                                    _fileImage!=null
                                    ?_presenter!.SendChat(lessionDetail: _detail!, discuss: discuss,imageFile: _fileImage)
                                        :_presenter!.SendChat(lessionDetail: _detail!, discuss: discuss);
                                    _message = '';
                                    _fileImage = null;
                                    _controllerMess = TextEditingController(text: _message);
                                    _isFeedback = false;
                                    _nameFeedback = '';
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
                  SizedBox(height: 4,)
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _itemChat(Discuss discuss, int index){
    List<dynamic> image =[discuss.imageLink];
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
            SizedBox(width: index == 0? 0:8,),
            ClipOval(
              child: ImageLoad.imageNetwork(discuss.avatar, index==0?40:30, index==0?40:30),
            ),
            SizedBox(width: 8,),
            SizedBox(
              width: getWidthDevice(context)/1.5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (discuss.nameFeedback==null||discuss.nameFeedback!.isEmpty)?SizedBox():CustomText(discuss.nameFeedback!, textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CommonColor.black)),
                  CustomText(discuss.content!, textStyle: TextStyle(fontSize: index==0?16:14, color: CommonColor.black, fontWeight: index==0?FontWeight.bold:FontWeight.normal))
                ],
              ),
            ),
          ],
        ),
        discuss.imageLink!=null
        ?Padding(
          padding: const EdgeInsets.only(left: 50, top: 8),
          child: InkWell(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewImageList(image, 0))),
              child: ImageLoad.imageNetwork(discuss.imageLink, getWidthDevice(context)*0.5, getWidthDevice(context)*0.5)),
        )
        :SizedBox(),
        SizedBox(height: 12,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: index==0?48:46,),
            InkWell(
              onTap: (){
                setState((){
                  _isFeedback = true;
                  _nameFeedback = '${discuss.name}';
                  _controllerMess = TextEditingController(text: _nameFeedback);
                });
              },
              child: CustomText(
                Languages.of(context).feedback,
                textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
              ),
            ),
            SizedBox(width: 50,),
            InkWell(
              onTap: (){
                _detail!.discuss!.removeAt(index);
                _presenter!.PostData(_detail!);
              },
              child: CustomText(
                  Languages.of(context).delete,
                  textStyle: TextStyle(color: CommonColor.blue, fontSize: 10)
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> getAccountInfor() async{
    _dataUser = await _presenter!.getAccountInfor();
    setState(()=>null);
  }
}
