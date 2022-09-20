import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/module/sign_up/sign_up_page.dart';
import 'package:online_tutor/res/images/image_view.dart';
import 'package:online_tutor/res/languages/languages.dart';

import '../../common/common_function.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPage();
  }

}

class _LoginPage extends State<LoginPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: (){
          hideKeyboard();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Image.asset(
              ImageView.banner_login,
              width: getWidthDevice(context),
              height: getHeightDevice(context)*0.3,
              fit: BoxFit.contain,
            ),
              Container(
                width: getWidthDevice(context),
                height: checkLandscape(context)?getWidthDevice(context)*0.7:getHeightDevice(context)*0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    color: CommonColor.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]
                ),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16,),
                    CustomText(Languages.of(context).login, textStyle: TextStyle(fontSize: 26, color: CommonColor.black, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16,),
                    TextFormField(
                      decoration: InputDecoration(
                        label: CustomText('${Languages.of(context).email}*'),
                        icon: Icon(Icons.mail)
                      ),
                      autovalidateMode:AutovalidateMode.always,
                      validator: (String? value){
                        return value!.isNotEmpty?validateEmail(value)?null:'${Languages.of(context).emailError}':null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (content){

                      },
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      decoration: InputDecoration(
                        label: CustomText('${Languages.of(context).password}*'),
                        icon: Icon(Icons.key)
                      ),
                    ),
                    SizedBox(height: 8,),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: (){

                        },
                        child: CustomText('${Languages.of(context).forgotPass}', textStyle: TextStyle(fontSize: 14, color: CommonColor.blue), textAlign: TextAlign.end),
                      ),
                    ),
                    SizedBox(
                      width: getWidthDevice(context)-16,
                      child: ElevatedButton(
                        onPressed: (){

                        },
                        child: CustomText(Languages.of(context).doLogin, textStyle: TextStyle(fontSize: 16, color: CommonColor.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          primary: CommonColor.blueLight,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical:8),
                        ),
                      ),
                    ),
                    SizedBox(height: 4,),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: CustomText(Languages.of(context).donAccount, textStyle: TextStyle(color: CommonColor.grey, fontSize: 12))
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(child: CustomText(Languages.of(context).signUp, textStyle: TextStyle(color: CommonColor.blue, fontSize: 13)),
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUpPage())),
                              ),
                            )
                          )
                        ]
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}