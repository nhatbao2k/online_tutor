import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/languages/languages.dart';

class Status{
  String _key;
  String _title;

  Status(this._key, this._title);

  String get getTitle => _title;

  String get getKey => _key;
  
  List<Status> getListStatus(BuildContext context){
    List<Status> statusList = [];
    statusList.add(Status('', Languages.of(context).status));
    statusList.add(Status(CommonKey.PENDING, Languages.of(context).pending));
    statusList.add(Status(CommonKey.READY, Languages.of(context).ready));
    return statusList;
  }
}