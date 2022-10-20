import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/social/post/model/news.dart';
import 'package:online_tutor/module/social/post/presenter/post_presenter.dart';

import '../../teacher/model/person.dart';
import 'model/image.dart';

class PostPage extends StatefulWidget {

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostPresenter? _presenter;
  List<ImageModel> _imageList=[];
  String _content = '';
  Person? _person;
  @override
  void initState() {
    _presenter = PostPresenter();
    _getAccountInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).createPost, nameFunction: Languages.of(context).post, callback: (value){
            if(_content.isEmpty){
              showToast(Languages.of(context).emptyContent);
            }else if(_imageList.length==0){
              showToast(Languages.of(context).imageNull);
            }else{
              News news = News(
                fullname: _person!.fullname,
                description: _content,
                comment: 1,
                userAvatar: _person!.avatar!=null?_person!.avatar:'',
                username: _person!.phone,
              );
              showLoaderDialog(context);
              _presenter!.getLink(_imageList, news).then((value) => _presenter!.CreateNewPost(value, news).then((value) {
                listenStatus(context, value);
              }));
            }
          },),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autocorrect: true,
                    decoration: InputDecoration.collapsed(
                      hintText: Languages.of(context).uQuestion,
                        hintStyle: TextStyle(fontSize: 18,fontFamily: 'LexendLight',color: CommonColor.grey)
                    ),
                    maxLines: 10,
                    onChanged: (value)=>setState(()=>_content=value),
                  ),
                ),
                Container(
                  width: getWidthDevice(context),
                  height: getHeightDevice(context)/13,
                  color: CommonColor.greyLight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 8,),
                      Expanded(
                        child: CustomText(
                          Languages.of(context).choseImage,
                          textStyle: TextStyle(fontSize: 16, color: CommonColor.blue)
                        ),
                      ),
                      IconButton(
                        onPressed: ()=>SelectImages((p0){
                          _imageList = _presenter!.getListImage(_imageList, p0!);
                          setState(()=> null);
                        }, CommonKey.CAMERA),
                        icon: Icon(
                          Icons.camera_alt,
                          color: CommonColor.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: ()=>SelectImages((p0) {
                          _imageList = _presenter!.getListImage(_imageList, p0!);
                          setState(()=> null);
                        }, ''),
                        icon: Icon(
                          Icons.image,
                          color: CommonColor.blue,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: List.generate(_imageList.length, (index) =>_itemImage(_imageList[index], index)),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemImage(ImageModel imageModel, int index){
    return Card(
        margin: EdgeInsets.all(8),
        child: Stack(
          children: [
            imageModel.imageLink!=null
                ?ImageLoad.imageNetwork('url', getWidthDevice(context)/2-16, getWidthDevice(context)/2-16)
                :Image(image: FileImage(imageModel.fileImage!), width: getWidthDevice(context)/2-16, height: getWidthDevice(context)/2-16,),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: CommonColor.greyLight,
                ),
                onPressed: ()=>setState(()=>_imageList.removeAt(index)),
              ),
            )
          ],
        )
    );
  }

  Future<void> _getAccountInfor() async{
    _person = await _presenter!.getAccountInfor();
    setState(()=>null);
  }
}
