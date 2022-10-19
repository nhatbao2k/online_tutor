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
  String _url = '';
  Future<String> UploadFilePdf(File file, MyClassDetail? myClassDetail,
      ClassCourse? course, MyClass? myClass, String fileName) async{
    String path = '${CommonKey.COURSE}/${course!.getIdCourse}/${course.getNameCourse}/${myClass!.idClass}/$fileName';
    final reference = FirebaseStorage.instance.ref().child('$path');

    final uploadTask = await reference.putData(file.readAsBytesSync()).then((p0) {

    }).catchError((onError){
      return '';
    });

    _url = await getLinkStorage(path).then((value) => _url=value);

    return _url;
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

  Future<bool> updateLessionDetail(LessionDetail lessionDetail) async{
    List<Map<String, dynamic>> discuss =[];
    List<Map<String, dynamic>> dataHomework =[];
    lessionDetail.homework!.forEach((element) => dataHomework.add(element.toJson()));
    await FirebaseFirestore.instance.collection('lession_detail').doc(replaceSpace(lessionDetail.idLessionDetail!)).update({
      'fileContent': lessionDetail.fileContent,
      'videoLink': lessionDetail.videoLink,
      'homework':dataHomework,
    }).then((value) => true).catchError((onError)=>false);
    return true;
  }
}