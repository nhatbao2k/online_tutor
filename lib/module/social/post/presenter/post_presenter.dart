import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/common/common_function.dart';

import '../../../../common/common_key.dart';
import '../../../../storage/shared_preferences.dart';
import '../../../teacher/model/person.dart';
import '../model/image.dart';
import '../model/news.dart';

class PostPresenter {
  List<ImageModel> getListImage(List<ImageModel> list, List<File> listFile){
    List<ImageModel> imageList = list;
    for(File f in listFile){
      imageList.add(ImageModel(fileImage: f));
    }
    return imageList;
  }


  Future<String> upLoadImage(File file, String username) async{
    String _url='';
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    String path = 'social/$username/${getCurrentTime()}.jpg';
    final uploadTask = storageRef
        .child("$path")
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
          _url= await getLinkStorage(path).then((value) => _url=value);
          break;
      }
    });
    return _url;
  }

  Future<bool> CreateNewPost(List<ImageModel> listImage, News news) async{
    List<String> _imageList = [];
    for(ImageModel model in listImage){
      String url = await upLoadImage(model.fileImage!, news.username!);
      _imageList.add(url);
    }
    DateTime currentPhoneDate = DateTime.now(); //DateTime
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    CollectionReference postNews = FirebaseFirestore.instance.collection('news');
    postNews.add(
      {
        "comments": 1,
        "description": news.description,
        "fullname": news.fullname,
        "mediaUrl": _imageList,
        "timestamp": myTimeStamp,
        "userAvatar": news.userAvatar,
        "username": news.username,
      }
    ).then((value) {
      postNews.doc(value.id).update({"id": value.id});
    }).catchError((onError)=>false);
    return true;
  }

  Future<Person> getAccountInfor() async{
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    Person person = Person.fromJson(user.toString());
    return person;
  }
}