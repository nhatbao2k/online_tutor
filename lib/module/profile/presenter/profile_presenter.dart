import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/common/common_key.dart';

import '../../../common/common_function.dart';
import '../../../storage/shared_preferences.dart';

class ProfilePresenter{
  Map<String, dynamic>? user;
  Future<Map<String, dynamic>> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

  Future<bool> UpdateImage(File file, String username) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    String path = '$username/${CommonKey.AVATAR}/$username.jpg';
    await storageRef
        .child("$path")
        .putFile(file, metadata).whenComplete(() async{
      String url= await getLinkStorage(path).then((value){
        FirebaseFirestore.instance.collection('users').doc(username).update({
          'avatar': value
        }).then((value) => true).catchError((onError)=>false);
        return value;
      });
    }).catchError((onError)=>false);
    return true;
  }
}