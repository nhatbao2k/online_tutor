import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/module/document/model/document.dart';

import '../../../common/common_key.dart';
import '../../../storage/shared_preferences.dart';

class DocumentProductPresenter{

  Future<String> UploadFilePdf(File file, String fileName) async{
    String url = '';
    String path = '${CommonKey.DOCUMENT}/${fileName}/${getCurrentTime()}/$fileName';
    final reference = FirebaseStorage.instance.ref().child('$path');

    final uploadTask = await reference.putData(file.readAsBytesSync()).then((p0) {

    }).catchError((onError){
      return url;
    });

    url = await getLinkStorage(path).then((value) => url=value);

    return url;
  }

  Future<bool> CreateDocument({required File imageFile, required Document document}) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final storageRef = FirebaseStorage.instance.ref();
    String path = '${CommonKey.DOCUMENT}/${document.name}/${document.id}/${getCurrentTime()}..jpg';
    await storageRef
        .child("$path")
        .putFile(imageFile, metadata).whenComplete(() async{
      document.imageLink = await getLinkStorage(path).then((value) => document.imageLink=value);
      Map<String, dynamic> data = document.toJson();
      FirebaseFirestore.instance.collection('documents').doc(document.id).set(data).whenComplete(() => true);
    });
    return true;
  }

  Future<Map<String, dynamic>> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Map<String, dynamic> userData = jsonDecode(user.toString());
    user = userData;
    return userData;
  }
}