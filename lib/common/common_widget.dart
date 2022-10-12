import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/res/images/image_view.dart';

import 'common_function.dart';
import 'image_load.dart';

Widget CustomText(String content, {textStyle, maxline, overFlow, textAlign}){
  return Text(
    content,
    style: textStyle,
    maxLines: maxline,
    textScaleFactor: 1.0,
    overflow: overFlow,
    textAlign: textAlign,
  );
}

Widget LoadingView(){
  return SpinKitCircle(
    color: Colors.blue,
    size: 75.0,
  );
}

CustomDialog(
    {required BuildContext context, IconData? iconData, String? title, required String content}){
  return showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconData!=null?Icon(
              iconData,
              color: CommonColor.yellowDeep,
              size: 80,
            ):SizedBox(),
            title==null||title.isEmpty?SizedBox():CustomText(title, overFlow: TextOverflow.ellipsis, maxline: 2, textAlign: TextAlign.center, textStyle: TextStyle(fontSize: 16, color: CommonColor.black, fontWeight: FontWeight.bold)),
          ],
        ),
        content: CustomText(content, overFlow: TextOverflow.ellipsis, maxline: 2, textAlign: TextAlign.center, textStyle: TextStyle(fontSize: 14, color: CommonColor.black,)),

        actions: [
          MaterialButton(
            onPressed: ()=>Navigator.pop(context),
            child: CustomText(Languages.of(context).close),
          )
        ],
      );
    }
  );
}

showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

Widget itemSeeMore(BuildContext context, String title, Function(String call) callback){
  return  Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: 8,),
      Expanded(child: CustomText(title, textStyle: TextStyle(color: CommonColor.blue, fontSize: 14, fontWeight: FontWeight.bold))),
      InkWell(
        onTap: ()=>callback(''),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(Languages.of(context).seeMore, textStyle: TextStyle(color: CommonColor.blue, fontWeight: FontWeight.bold)),
            Icon(Icons.double_arrow, color: CommonColor.blue,)
          ],
        ),
      ),
      SizedBox(width: 8,),
    ],
  );
}

Widget itemClass(BuildContext context, String title, String content1, String content2, Function(bool click) onClick){
  return InkWell(
    onTap: () => onClick(true),
    child: Container(
      height: 300,
      width: 250,
      padding: EdgeInsets.all(4),
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoad.imageNetwork('', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          CustomText('Lập trình javascript ssssssssssssss', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          CustomText(
              'GV: Đỗ Oanh Cường',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
          Spacer(),
          Container(
            width: getWidthDevice(context),
            margin: EdgeInsets.only(left: 8, right: 8),
            child: ElevatedButton(
              onPressed: ()=>onClick(true),
              child: CustomText(Languages.of(context).signUp),
            ),
          )
        ],
      ),
    ),
  );
}

Widget NoDataView(String mess){
  return Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset('${ImageView.not_found}', ),
      SizedBox(height: 8,),
      CustomText(mess, textStyle: TextStyle(color: CommonColor.grey, fontSize: 20))
    ],
  );
}

Future<void> cropImage(Function (File?) onSelectFile, String type,BuildContext context) async {
  final pickedImage =
  await ImagePicker().getImage(source: CommonKey.CAMERA==type?ImageSource.camera : ImageSource.gallery);
  if(pickedImage==null){
    onSelectFile(null);
  }else {
    CroppedFile? croppedFile =  await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: CommonColor.blue,
            toolbarWidgetColor: CommonColor.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      onSelectFile(File(croppedFile.path));
    }
  }
}

Future<void> selectImages(Function (List<File>?) onSelectFile, bool type) async {
  if(type){
    final pickedCam = await ImagePicker().getImage(source:ImageSource.camera);
    if(pickedCam==null){
      onSelectFile(null);
    }else {
      List<File> fileCam = [];
      fileCam.add(File(pickedCam.path));
      onSelectFile(fileCam);
    }
  }else{
    final pickedImages = await ImagePicker().pickMultiImage();
    if(pickedImages==null){
      onSelectFile(null);
    }else {
      if(pickedImages.isNotEmpty){
        List<File> file =[];
        for(XFile i in pickedImages){
          file.add(File(i.path));
        }
        onSelectFile(file);
      }
    }
  }
}

showToast(String content){
  Fluttertoast.showToast(
    msg: content,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: CommonColor.red,
    textColor: CommonColor.white,
    fontSize: 16
  );
}

Widget itemCourseAdmin(BuildContext context, String title, String content, String imageLink,Function(bool click) onClickEdit, Function(bool click) onClickDelete, Function(String id) onClick){
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 300,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: checkLandscape(context)?getWidthDevice(context)/4:getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoad.imageNetwork('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          CustomText('$title', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          CustomText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
          Spacer(),
          Container(
            width: getWidthDevice(context),
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: CommonColor.blue,),
                  onPressed: ()=>onClickEdit(true),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever,color: CommonColor.blue,),
                  onPressed: ()=>onClickDelete(true),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget itemCourse(BuildContext context, String title, String content, String imageLink, Function(String id) onClick){
  return InkWell(
    onTap: () => onClick(''),
    child: Container(
      height: 270,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: checkLandscape(context)?getWidthDevice(context)/4:getWidthDevice(context)/2-16,
      padding: EdgeInsets.all(4),
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageLoad.imageNetwork('$imageLink', 150, getWidthDevice(context)),
          SizedBox(height: 16,),
          CustomText('$title', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
          SizedBox(height: 8,),
          CustomText(
              'GV: $content',
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: CommonColor.black,
              ),
              maxline: 2
          ),
        ],
      ),
    ),
  );
}

Widget ButtonDefault(String content, Function(String data) onClick){
  return ElevatedButton(
    onPressed: ()=>onClick(''),
    child: CustomText(content, textStyle: TextStyle(fontSize: 14, color: CommonColor.white)),
  );
}

Widget ButtonIcon(IconData iconData, Function(String data) onClick){
  return ElevatedButton(
    onPressed: ()=>onClick(''),
    child: Icon(iconData, color: CommonColor.white,),
  );
}

