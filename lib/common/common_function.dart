
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:online_tutor/restart_page.dart';
import 'package:online_tutor/storage/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../languages/languages.dart';
import 'common_widget.dart';
import 'package:intl/intl.dart';
double getWidthDevice(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getHeightDevice(BuildContext context){
  return MediaQuery.of(context).size.height;
}

bool checkLandscape(BuildContext context){
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

bool validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return false;
  else
    return true;
}

void hideKeyboard(){
  FocusManager.instance.primaryFocus?.unfocus();
}

int checkVarriable(dynamic value){
  if(value is String){
    return 0;
  }else if(value is int){
    return 1;
  }else if(value is double){
    return 2;
  }else if(value is bool){
    return 3;
  }else{
    return 4;
  }
}

int partInterger(dynamic value){
  return int.parse(value);
}

String partString(dynamic value){
  return value.toString();
}

double partDouble(dynamic value){
  return double.parse(value);
}

bool partBool(dynamic value){
  return value.toString()=='true'?true:false;
}

Future<void> signOut(BuildContext context) async {
  await SharedPreferencesData.DeleteAll();
  await FirebaseAuth.instance.signOut();
  RestartPage.restartApp(context);
}

bool checkEmpty(String content){
  return content.isEmpty;
}

String replaceEmail(String email){
  return email.replaceAll("@", "").replaceAll(".", "");
}

String splitSpace(String content){
  var data = content.split(" ");
  return data[0];
}

void listenStatus(BuildContext context, bool value){
  Navigator.pop(context);
  if(value){
    Navigator.pop(context);
    showToast(Languages.of(context).onSuccess);
  }else{
    showToast(Languages.of(context).addFailure);
  }
}

Future<String> getLinkStorage(String link) async{
  final ref = FirebaseStorage.instance.ref().child("${link}");
  String url = (await ref.getDownloadURL()).toString();
  return url;
}

String replaceSpace(String content){
  return content.replaceAll(" ", "");
}

String getYoutubeId(String url){
  String? id = YoutubePlayer.convertUrlToId(url);
  return id!;
}

Timestamp getTimestamp(){
  DateTime currentDate = DateTime.now(); //DateTime
  Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
  return myTimeStamp;
}

String splitSpaceEnd(String content){
  var data = content.split(" ");
  return data[data.length-1];
}

List splitList(String content){
  return content.split(":");
}

String getDateWeek(int day){
  var d = DateTime.now();
  var weekDay = d.weekday;
  var date = d.subtract(Duration(days: weekDay-day));
  var formatterDate = DateFormat('dd/MM');
  String value = formatterDate.format(date);

  return value;
}

String getDateNow(){
  var now = DateTime.now();
  var formatterDate = DateFormat('dd/MM');
  String actualDate = formatterDate.format(now);
  return actualDate;
}

String getNameDateNow(){
  var now = DateTime.now();
  var formatterDate = DateFormat('EEEE').format(now);
  return formatterDate.toString();
}

String getCurrentTime() {
  DateTime now = DateTime.now();
  int time=now.millisecondsSinceEpoch;
  return "$time";
}

String readTimestamp(Timestamp? timestamp) {
  if(timestamp==null) return "";
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' ngày trước';
    } else {
      time = diff.inDays.toString() + ' ngày trước';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' tuần trước';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' tuần trước';
    }
  }
  return time;
}

String replaceKey(String content, String keyFlow){
  return content.replaceAll(keyFlow, "");
}

