import 'package:flutter/material.dart';
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

