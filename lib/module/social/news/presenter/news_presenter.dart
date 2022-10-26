import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/common_key.dart';
import '../../../../storage/shared_preferences.dart';

class NewsPresenter{
  Future<Map<String, dynamic>> getUserInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }
  
  void DeleteNews(String idNews){
    FirebaseFirestore.instance.collection('news').doc(idNews).delete();
  }
}