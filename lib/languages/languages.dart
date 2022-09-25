import 'package:flutter/material.dart';

abstract class Languages{
  static Languages of(BuildContext context){
    return Localizations.of(context, Languages);
  }
  String get appName;
  String get login;
  String get email;
  String get password;
  String get emailError;
  String get passError;
  String get emailEmpty;
  String get forgotPass;
  String get doLogin;
  String get signUp;
  String get donAccount;
  String get fullName;
  String get phone;
  String get close;
  String get nameEmpty;
  String get phoneEmpty;
  String get phoneError;
  String get passNotEqual;
  String get weakPass;
  String get alert;
  String get existEmail;
  String get accountWrong;
  String get passWrong;
  String get classNew;
  String get seeMore;
  String get comment;
  String get registerAdvise;
  String get enterContent;
  String get submitInfo;
}