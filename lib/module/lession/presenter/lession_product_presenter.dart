import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/module/lession/model/lession_detail.dart';

import '../../../common/common_key.dart';
import '../../class/model/class_course.dart';
import '../../class/model/my_class.dart';
import '../../class/model/my_class_detail.dart';

class LessionProductPresenter{
  Future<String> UploadFilePdf(File file, MyClassDetail? myClassDetail,
      ClassCourse? course, MyClass? myClass, String fileName) async{
    String path = '${CommonKey.COURSE}/${course!.getIdCourse}/${course.getNameCourse}/${myClass!.idClass}/$fileName';
    final reference = FirebaseStorage.instance.ref().child('$path');
    final uploadTask = reference.putData(file.readAsBytesSync()).catchError((onError){
      return '';
    });
    String url = '';
    await getLinkStorage(path).then((value) => url=value);

    return url;
  }
  
  Future<bool> CreateLessionDetail(LessionDetail lessionDetail) async{
    Map<String, dynamic> data = lessionDetail.toJson();
    // List<Map<String, dynamic>> homework =[];
    // homeworkList.forEach((element) {homework.add(element.toJson());});
    await FirebaseFirestore.instance.collection('lession_detail').doc(lessionDetail.idLessionDetail).set(/*{
      'idLessionDetail': lessionDetail.idLessionDetail,
      'nameLession': lessionDetail.nameLession,
      'fileContent': lessionDetail.fileContent,
      'videoLink': lessionDetail.videoLink,
      'homework': homework
    }*/data).catchError((onError)=> false);
    return true;
  }
}