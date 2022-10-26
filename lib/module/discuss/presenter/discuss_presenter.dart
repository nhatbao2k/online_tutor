import 'dart:convert';

import 'package:online_tutor/module/lession/model/discuss.dart';
import 'package:online_tutor/module/lession/model/lession_detail.dart';

import '../../../common/common_key.dart';
import '../../../storage/shared_preferences.dart';

class DiscussPresenter{

  Future<Map<String, dynamic>> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

  Future SendChat(LessionDetail lessionDetail, Discuss discuss) async{

  }
}