import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/res/images/image_view.dart';
import 'package:online_tutor/res/languages/languages.dart';

import '../../common/common_function.dart';

class SignUpPage extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpPage();
  }
  
}

class _SignUpPage extends State<SignUpPage>{
  String _fullname='';
  String _phone='';
  String _email='';
  String _pass1='';
  String _pass2='';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: CustomText(Languages.of(context).signUp, textStyle: TextStyle(color: CommonColor.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => hideKeyboard(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4,),
                Image.asset(
                    ImageView.banner_register,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          label: CustomText('${Languages.of(context).fullName} *'),
                          icon: Icon(Icons.key)
                      ),
                      onChanged: (fullname){
                        _fullname=fullname;
                        setState((){
                        });
                      },
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      decoration: InputDecoration(
                          label: CustomText('${Languages.of(context).phone} *'),
                          icon: Icon(Icons.key)
                      ),
                      onChanged: (value){
                      _phone=value;
                      setState((){
                      });
                    },
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      decoration: InputDecoration(
                          label: CustomText('${Languages.of(context).email} *'),
                          icon: Icon(Icons.key)
                      ),
                      onChanged: (value){
                        _email=value;
                        setState((){
                        });
                      },
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      decoration: InputDecoration(
                          label: CustomText('${Languages.of(context).password} *'),
                          icon: Icon(Icons.key)
                      ),
                      onChanged: (value){
                        _pass1=value;
                        setState((){
                        });
                      },
                    ),
                    SizedBox(height: 16,),
                    TextFormField(
                      decoration: InputDecoration(
                          label: CustomText('${Languages.of(context).password} *'),
                          icon: Icon(Icons.key)
                      ),
                      onChanged: (value){
                        _pass1=value;
                        setState((){
                        });
                      },
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                      width: getWidthDevice(context)-16,
                      child: ElevatedButton(
                        onPressed: (){
                          register(_email, _pass1);
                        },
                        child: CustomText(Languages.of(context).signUp, textStyle: TextStyle(fontSize: 16, color: CommonColor.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          primary: CommonColor.blueLight,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical:8),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register(String email, pass) async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.pop(context);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}