import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/module/class/model/class_course.dart';
import 'package:online_tutor/module/class/model/my_class.dart';

import '../../../common/common_key.dart';
import '../../../storage/shared_preferences.dart';

class ClassAddPresenter{
  Future<bool> createClass(File fileImage, ClassCourse course, MyClass myClass) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("${CommonKey.COURSE}/${course.getIdCourse}/${course.getNameCourse}/${myClass.idClass}/class.jpg")
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
          String url = await getLinkAvatar(course.getIdCourse!, course.getNameCourse!, myClass.idClass!);
          FirebaseFirestore.instance
              .collection('class')
              .doc(myClass.idClass)
              .set({
            'idClass': myClass.idClass,
            'idCourse': course.getIdCourse,
            'idTeacher': course.getIdTeacher,
            'teacherName': course.getNameTeacher,
            'status': myClass.status,
            'price': myClass.price,
            'nameClass': myClass.nameClass,
            'describe': myClass.describe,
            'imageLink': url,
            'startDate': myClass.startDate,
            'startHours': myClass.startHours,
            'subscribe': [
              'admin'
            ]
          }).then((value) => true);
          break;
      }
    });
    return true;
  }

  Future<bool> UpdateClass({File? file, ClassCourse? course, MyClass? myClass, String? url}) async{
    if(file!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
      final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
      final uploadTask = storageRef
          .child("${CommonKey.COURSE}/${course!.getIdCourse}/${course.getNameCourse}/${myClass!.idClass}/class.jpg")
          .putFile(file, metadata);

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
            String urlImage = await getLinkAvatar(course.getIdCourse!, course.getNameCourse!, myClass.idClass!);
            _updateClass(course, myClass, urlImage);
            break;
        }
      });
    }else{
      _updateClass(course!, myClass!, url!);
    }
    return true;
  }
  void _updateClass(ClassCourse course, MyClass myClass, String url){
    FirebaseFirestore.instance.collection('class').doc(myClass.idClass)
        .update({
      'status': myClass.status,
      'price': myClass.price,
      'nameClass': myClass.nameClass,
      'describe': myClass.describe,
      'imageLink': url,
      'startDate': myClass.startDate,
      'startHours': myClass.startHours
        });
  }

  Future<String> getLinkAvatar(String idCourse, String nameCourse, String idClass) async{
    final ref = FirebaseStorage.instance.ref().child("${CommonKey.COURSE}/$idCourse/$nameCourse/$idClass/class.jpg");
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

  void deleteClass(String idClass){
    FirebaseFirestore.instance.collection('class').doc(idClass).delete();
  }

  Future<String> getUserInfo() async{
    String phone = '';
    dynamic data = await SharedPreferencesData.GetData(CommonKey.USER);
    if(data!=null){
      Map<String, dynamic>json = jsonDecode(data.toString());
      phone = json['phone']!=null?json['phone']:'';
    }
    return phone;
  }

  void RegisterClass(String idClass, List<dynamic> userRegister, String idCourse){
    FirebaseFirestore.instance.collection('class').doc(idClass).update({
      'subscribe': userRegister
    });
    FirebaseFirestore.instance.collection('course').doc(idCourse).update({
      'subscribe':userRegister
    });
  }
}