import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/languages/languages.dart';

import '../res/images/image_view.dart';

enum AppType{
  appbar_home,
  appbar_home_social,
  child,
  childFunction
}
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{

  AppType appType;
  String title;
  String? nameFunction;
  Function(String content)? callback;

  CustomAppBar({required this.appType, required this.title, this.callback, this.nameFunction});

  @override
  State createState() => _CustomAppBar(appType, title, callback, nameFunction);

  @override
  // TODO: implement preferredSize
  final Size preferredSize = Size.fromHeight(kMinInteractiveDimension);
}

class _CustomAppBar extends State<CustomAppBar>{

  AppType? _appType;
  String? _title;
  String? _nameFunction;
  Function(String content)? callback;
  _CustomAppBar(this._appType, this._title, this.callback, this._nameFunction);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(_appType==AppType.appbar_home){
      return _appBarHome();
    }else if(_appType==AppType.childFunction){
      return _appBarChildFunction();
    }else if(_appType==AppType.appbar_home_social){
      return _appBarHomeSocial();
    }
    return _appBarChild();
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

  Widget _appBarHomeSocial(){
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
            onPressed:()=>callback!(''),
            icon: Icon(Icons.message, color: CommonColor.blue,),
          )
        ],
      ),
    );
  }

  Widget _appBarChild(){
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
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),
          SizedBox(width: 8,),
          Expanded(child: CustomText(_title!, textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          SizedBox(width: 52,)
        ],
      ),
    );
  }

  Widget _appBarChildFunction(){
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
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back, color: CommonColor.blue,)),
          SizedBox(width: 8,),
          Expanded(child: CustomText(_title!, textStyle: TextStyle(color: CommonColor.blueLight, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          ElevatedButton(
              onPressed: ()=> callback!(''),
              child: CustomText(_nameFunction!, textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CommonColor.white))),
          SizedBox(width: 8,)
        ],
      ),
    );
  }
}