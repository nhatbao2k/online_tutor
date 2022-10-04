import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/res/images/image_view.dart';
import 'package:online_tutor/restart_page.dart';

import '../../common/common_function.dart';
import '../../languages/languages.dart';

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
  bool _seePass1 = false;
  bool _seePass2 = false;
  final _formFullname = GlobalKey<FormState>();
  final _formPhone = GlobalKey<FormState>();
  final _formPass1 = GlobalKey<FormState>();
  final _formPass2 = GlobalKey<FormState>();
  final _formEmail = GlobalKey<FormState>();
  final _user = FirebaseAuth.instance.currentUser;
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
                    Form(
                      key: _formFullname,
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: CustomText('${Languages.of(context).fullName} *'),
                            icon: Icon(Icons.key)
                        ),
                        onChanged: (fullname){
                          _fullname=fullname;
                          setState((){
                          });
                        },
                        validator: (value){
                          if(value!.isEmpty){
                            return '\u26A0 ${Languages.of(context).nameEmpty}';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16,),
                    Form(
                      key: _formPhone,
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: CustomText('${Languages.of(context).phone} *'),
                            icon: Icon(Icons.key)
                        ),
                        onChanged: (value){
                        _phone=value;
                        setState((){
                        });
                      },
                        keyboardType: TextInputType.phone,
                        validator: (value){
                          if(value!.isEmpty){
                            return '\u26A0 ${Languages.of(context).phoneEmpty}';
                          }else if(value.length != 10){
                            return '\u26A0 ${Languages.of(context).phoneError}';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16,),
                    Form(
                      key: _formEmail,
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: CustomText('${Languages.of(context).email} *'),
                            icon: Icon(Icons.key)
                        ),
                        onChanged: (value){
                          _email=value;
                          setState((){
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty){
                            return '\u26A0 ${Languages.of(context).emailEmpty}';
                          }else if(!validateEmail(value)){
                            return '\u26A0 ${Languages.of(context).emailError}';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16,),
                    Form(
                      key: _formPass1,
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: CustomText('${Languages.of(context).password} *'),
                            icon: Icon(Icons.key),
                          suffixIcon: IconButton(
                            onPressed: ()=>setState(()=>_seePass1=!_seePass1),
                            icon: Icon(
                                _seePass1?Icons.visibility:Icons.visibility_off
                            ),
                          )
                        ),
                        onChanged: (value){
                          _pass1=value;
                          setState((){
                          });
                        },
                        keyboardType: TextInputType.text,
                        obscureText: !_seePass1,
                        validator: (value){
                          if(value!.isEmpty){
                            return '\u26A0 ${Languages.of(context).passError}';
                          }else if(value.length<6){
                            return '\u26A0 ${Languages.of(context).weakPass}';
                          }else if(_pass1!=_pass2){
                            return '\u26A0 ${Languages.of(context).passNotEqual}';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16,),
                    Form(
                      key: _formPass2,
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: CustomText('${Languages.of(context).password} *'),
                            icon: Icon(Icons.key),
                          suffixIcon: IconButton(
                            onPressed: ()=>setState(()=>_seePass2=!_seePass2),
                            icon: Icon(
                                _seePass2?Icons.visibility:Icons.visibility_off
                            ),
                          )
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value){
                          _pass2=value;
                          setState((){
                          });
                        },
                        obscureText: _seePass2,
                        validator: (value){
                          if(value!.isEmpty){
                            return '\u26A0 ${Languages.of(context).passError}';
                          }else if(value.length<6){
                            return '\u26A0 ${Languages.of(context).weakPass}';
                          }else if(_pass1!=_pass2){
                            return '\u26A0 ${Languages.of(context).passNotEqual}';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 16,),
                    SizedBox(
                      width: getWidthDevice(context)-16,
                      child: ElevatedButton(
                        onPressed: (){
                          if(_formFullname.currentState!.validate()){
                          }
                          if(_formPhone.currentState!.validate()){
                          }
                          if(_formEmail.currentState!.validate()){
                          }
                          if(_formPass1.currentState!.validate()){
                          }
                          if(_formPass2.currentState!.validate()){
                          }
                          if(_pass1==_pass2 && _pass1.isNotEmpty && _pass2.isNotEmpty
                          && _fullname.isNotEmpty && _email.isNotEmpty && _phone.isNotEmpty
                          ){
                            showLoaderDialog(context);
                            register(_email, _pass1);
                          }

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
      // final user = FirebaseAuth.instance.currentUser;
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      // await user!.updateDisplayName(_phone);
      await _user?.updateDisplayName(_phone);
      FirebaseFirestore.instance.collection('users').doc(_phone).set({
        "phone": _phone,
        "avatar": "",
        "fullname":_fullname,
        "role":"MEMBER",
        "email":_email,
        'address': '',
        'birthday': '',
        'describe': '',
        'office': ''
      }).then((value) => {
        RestartPage.restartApp(context),
        Navigator.pop(context),
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        CustomDialog(context: context, iconData: Icons.warning_rounded, title: Languages.of(context).alert, content: Languages.of(context).existEmail);
      }else{

      }
    } catch (e) {
      print(e);
    }
  }
}