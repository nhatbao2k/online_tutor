import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/common_key.dart';
import '../../../../storage/shared_preferences.dart';

class NewsPresenter{
  Future<String> getUserInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    String username = '';
    if(user.toString().isNotEmpty){
      Map<String, dynamic>json = jsonDecode(user.toString());
      username = json['phone'];
    }
    return username;
  }
  
  void DeleteNews(String idNews){
    FirebaseFirestore.instance.collection('news').doc(idNews).delete();
  }
}