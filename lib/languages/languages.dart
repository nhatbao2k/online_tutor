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
  String get qa;
  String get uNeed;
  String get accountInfo;
  String get noData;
  String get hello;
  String get address;
  String get birthday;
  String get office;
  String get describeInfo;
  String get save;
  String get createCourse;
  String get createNew;
  String get idCourse;
  String get nameCourse;
  String get idTeacher;
  String get teacherName;
  String get teacherAdd;
  String get addFailure;
  String get onSuccess;
  String get choseTeacher;
  String get choseId;
  String get idCourseEmpty;
  String get nameCourseEmpty;
  String get imageNull;
  String get myClass;
  String get classAdd;
  String get idClass;
  String get status;
  String get nameClass;
  String get describeClass;
  String get ready;
  String get pending;
  String get idClassEmpty;
  String get subjectEmpty;
  String get statusNull;
}