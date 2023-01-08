import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';

class TeacherAddPresenter{

  Future<bool> createAccount(
      {File? file,
      String? name,
      String? phone,
      String? email,
      String? address,
      String? birthday,
      String? describe}) async{
    try {
      final user = FirebaseAuth.instance.currentUser;
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: phone!,
      ).then((value) async{
        await user?.updateDisplayName(phone);
        if(file!=null){
          String link = '';

            final metadata = SettableMetadata(contentType: "image/jpeg");
            final storageRef = FirebaseStorage.instance.ref();
            String path = '$phone/${CommonKey.AVATAR}/$phone.jpg';
            await storageRef
                .child("$path")
                .putFile(file, metadata).whenComplete(() async{
              link = await getLinkStorage(path).then((value) => link=value);
              addTeacher(name!, phone, email, address!, birthday!, describe!);
            });

        }else{
          addTeacher(name!, phone, email, address!, birthday!, describe!);
        }
        await FirebaseAuth.instance.signOut();
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return false;
      }else{

      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<void> upLoadAvatar(File fileImage, String keyUser) async{
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("$keyUser/${CommonKey.AVATAR}/$keyUser.jpg")
        .putFile(fileImage, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
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

          break;
      }
    });
  }

  Future<bool> addTeacher(String name, String phone, String email, String address, String birthday, String describe) async{
    String url = '';
    try {
      final ref = FirebaseStorage.instance.ref().child("$phone/${CommonKey.AVATAR}/$phone.jpg");
      url = await getLinkStorage("$phone/${CommonKey.AVATAR}/$phone.jpg");
    } on Exception catch (e) {
      // TODO
      url = '';
    }
    await FirebaseFirestore.instance
    .collection('users')
    .doc(phone)
    .set({
      "avatar": url,
      'fullname': name,
      'phone': phone,
      'role': CommonKey.TEACHER,
      'email': email,
      'address': address,
      'birthday': birthday,
      'describe': describe,
      'office': 'Giáo viên',
      'isLooked': false
    }).then((value) => true);
    return true;
  }

  Future<bool> updateTeacher(File? imageFile,String name, String phone, String address, String birthday, String describe, String keyUser, String linkImage) async{
    String link = linkImage;
    if(imageFile!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      String path = '$keyUser/${CommonKey.AVATAR}/$keyUser.jpg';
      await storageRef
          .child("$path")
          .putFile(imageFile, metadata).whenComplete(() async{
        link = await getLinkStorage(path).then((value) => link=value);
      });
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(phone)
        .update({
      "avatar": link,
      'fullname': name,
      'address': address,
      'birthday': birthday,
      'describe': describe,
    }).then((value) => true).catchError((onError)=>false);
    return true;
  }
}