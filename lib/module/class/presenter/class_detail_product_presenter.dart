import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/module/class/model/my_class_detail.dart';

import '../../../common/common_function.dart';
import '../../../common/common_key.dart';
import '../model/class_course.dart';
import '../model/my_class.dart';

class ClassDetailProductPresenter{
  Future<bool> createClassDetail(File fileImage, MyClassDetail myClassDetail, ClassCourse course, MyClass myClass) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    String link = "${CommonKey.COURSE}/${course.getIdCourse}/${course.getNameCourse}/${myClass.idClass}/class_detail.jpg";
    final uploadTask = storageRef
        .child(link)
        .putFile(fileImage, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async{
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
        // Handle unsuccessful uploads
          break;
        case TaskState.success:
        // Handle successful uploads on complete
          String url = await getLinkStorage(link);
          List<Map<String, dynamic>> lession =[];
          myClassDetail.lession!.forEach((element) {lession.add(element.toJson());});
          FirebaseFirestore.instance
              .collection('class_detail')
              .doc(myClassDetail.idClassDetail)
              .set({
            'idClassDetail': myClassDetail.idClassDetail,
            'idClass': myClassDetail.idClass,
            'teacherName': course.getNameTeacher,
            'nameClass': myClassDetail.nameClass,
            'describe': myClassDetail.describe,
            'imageLink': url,
            'lession': lession
          }).onError((error, stackTrace) => false);
          break;
      }
    });
    return true;
  }

  Future<bool> UpdateClassDetail(
      {File? fileImage, MyClassDetail? myClassDetail,
      ClassCourse? course, MyClass? myClass, String? linkImage}) async{
    if(fileImage!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
      String link = "${CommonKey.COURSE}/${course!.getIdCourse}/${course.getNameCourse}/${myClass!.idClass}/class_detail.jpg";
      final uploadTask = storageRef
          .child(link)
          .putFile(fileImage, metadata);

// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async{
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress =
                100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
          // Handle unsuccessful uploads
            break;
          case TaskState.success:
          // Handle successful uploads on complete
            String url = await getLinkStorage(link);
            List<Map<String, dynamic>> lession =[];
            myClassDetail!.lession!.forEach((element) {lession.add(element.toJson());});
            _updateClassDetail(myClassDetail, course, myClass, url, lession);
            break;
        }
      });
    }else{
      List<Map<String, dynamic>> lession =[];
      myClassDetail!.lession!.forEach((element) {lession.add(element.toJson());});
      _updateClassDetail(myClassDetail, course!, myClass!, linkImage!, lession);
    }
    return true;
  }

  void _updateClassDetail(MyClassDetail myClassDetail, ClassCourse course, MyClass myClass, String linkImage, List<Map<String, dynamic>> lession){
    FirebaseFirestore.instance
        .collection('class_detail')
        .doc(myClassDetail.idClassDetail)
        .update({
      'describe': myClassDetail.describe,
      'imageLink': linkImage,
      'lession': lession
    }).onError((error, stackTrace) => false);
  }
}