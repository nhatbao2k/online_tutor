import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/module/lession/model/discuss.dart';
import 'package:online_tutor/module/lession/model/lession_detail.dart';

import '../../../common/common_function.dart';
import '../../../common/common_key.dart';
import '../../../storage/shared_preferences.dart';

class DiscussPresenter{

  Future<Map<String, dynamic>> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }

  Future SendChat({required LessionDetail lessionDetail, required Discuss discuss, File? imageFile}) async{
    lessionDetail.discuss!.add(discuss);
    if(imageFile!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      String path = 'discuss/${lessionDetail.nameLession}/${discuss.name}/${getCurrentTime()}.jpg';
      await storageRef
          .child("$path")
          .putFile(imageFile, metadata).whenComplete(() async{
        discuss.imageLink = await getLinkStorage(path).then((value) => discuss.imageLink=value);
        PostData(lessionDetail);
      });
    }else{
      PostData(lessionDetail);
    }
  }

  void PostData(LessionDetail lessionDetail){
    List<Map<String, dynamic>> dataDiscuss =[];
    lessionDetail.discuss!.forEach((element) => dataDiscuss.add(element.toJson()));
    print(dataDiscuss);
    FirebaseFirestore.instance.collection('lession_detail').doc(lessionDetail.idLessionDetail).update({
      'discuss': dataDiscuss
    });
  }
}