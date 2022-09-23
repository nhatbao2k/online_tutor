import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/languages/languages.dart';

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

Widget CustomAppBar(String title){
  return AppBar(
    title: CustomText(title, textStyle: TextStyle(color: CommonColor.white)),
    backgroundColor: CommonColor.blueLight,
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

