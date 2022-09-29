import 'dart:convert';

import 'package:online_tutor/common/common_key.dart';

import '../../storage/shared_preferences.dart';

class ProfilePresenter{
  Map<String, dynamic>? user;
  Future<Map<String, dynamic>> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }
}