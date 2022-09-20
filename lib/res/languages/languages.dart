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
}