import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:online_tutor/common/common_color.dart';

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

int checkVarriable(dynamic value){
  if(value is String){
    return 0;
  }else if(value is int){
    return 1;
  }else if(value is double){
    return 2;
  }else if(value is bool){
    return 3;
  }else{
    return 4;
  }
}

int partInterger(dynamic value){
  return int.parse(value);
}

String partString(dynamic value){
  return value.toString();
}

double partDouble(dynamic value){
  return double.parse(value);
}

bool partBool(dynamic value){
  return value.toString()=='true'?true:false;
}
