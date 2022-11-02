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
  String get classDetail;
  String get classDetailNew;
  String get idClassDetail;
  String get nameLession;
  String get idLession;
  String get delete;
  String get nameClassEmpty;
  String get idLessionEmpty;
  String get nameLessionEmpty;
  String get infor;
  String get rating;
  String get lessionList;
  String get content;
  String get exercise;
  String get answer;
  String get discuss;
  String get fileQuestion;
  String get fileAnswer;
  String get linkExercise;
  String get question;
  String get youNeed;
  String get classStudy;
  String get course;
  String get requireLogin;
  String get hourEmpty;
  String get startHours;
  String get time;
  String get monday;
  String get tuesday;
  String get wednesday;
  String get thurday;
  String get friday;
  String get saturday;
  String get sunday;
  String get schedule;
  String get teacher;
  String get requireClass;
  String get denyAccess;
  String get post;
  String get createPost;
  String get uQuestion;
  String get edit;
  String get choseImage;
  String get emptyContent;
  String get onFailure;
  String get submit;
  String get indexQA;
  String get right;
  String get wrong;
  String get anwserHomework;
  String get supperGood;
  String get wellDone;
  String get bad;
  String get averageExam;
  String get exellent;
  String get good;
  String get goodless;
  String get low;
  String get result;
  String get resultCategory;
  String get feedback;
  String get document;
  String get documentNews;
  String get nameDocument;
}