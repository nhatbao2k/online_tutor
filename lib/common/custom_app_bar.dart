import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/languages/languages.dart';

import '../res/images/image_view.dart';

enum AppType{
  appbar_home,
  child
}
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{

  AppType appType;
  String title;
  Function(String content)? callback;

  CustomAppBar({required this.appType, required this.title, this.callback});

  @override
  State createState() => _CustomAppBar(appType, title, callback);

  @override
  // TODO: implement preferredSize
  final Size preferredSize = Size.fromHeight(kMinInteractiveDimension);
}

class _CustomAppBar extends State<CustomAppBar>{

  AppType? appType;
  String? title;
  Function(String content)? callback;
  _CustomAppBar(this.appType, this.title, this.callback);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(appType==AppType.appbar_home){
      return _appBarHome();
    }
    return _appBarHome();
  }

  Widget _appBarHome(){
    return Container(
      width: getWidthDevice(context),
      height: 52,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageView.tab_bar),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8,),
        Image.asset(ImageView.logo, height: 30, width: 30,),
          SizedBox(width: 8,),
          Expanded(child: CustomText(Languages.of(context).appName, textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.search_sharp, color: CommonColor.blue,),
          )
        ],
      ),
    );
  }
}