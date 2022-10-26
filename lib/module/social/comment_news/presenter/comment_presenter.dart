import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/module/social/comment_news/model/comment.dart';

import '../../../../common/common_function.dart';

class CommentPresenter{

  Future SendChat({required String idNews,required Comment comment, File? imageFile, required type}) async{
    if(imageFile!=null){
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      String path = 'comment/${idNews}/${comment.name}/${getCurrentTime()}.jpg';
      await storageRef
          .child("$path")
          .putFile(imageFile, metadata).whenComplete(() async{
        comment.imageLink = await getLinkStorage(path).then((value) => comment.imageLink=value);
        CommonKey.UPDATE_CHILD==type
            ?UpdateChildComment(comment, idNews)
            :_PostData(comment, idNews);
      });
    }else{
      CommonKey.UPDATE_CHILD==type
          ?UpdateChildComment(comment, idNews)
          :_PostData(comment, idNews);
    }
  }

  void _PostData(Comment comment, String idNews){
    Map<String, dynamic> commentList = comment.toJson();
    FirebaseFirestore.instance.collection('comment').doc(idNews).collection(idNews).add(commentList).then((value) {
      FirebaseFirestore.instance.collection('comment').doc(idNews).collection(idNews).doc(value.id).update({
        'id':value.id
      });
    });
  }

  void UpdateChildComment(Comment comment, String idNews){
    List<Map<String, dynamic>> listComment = [];
    comment.listComment!.forEach((element) => listComment.add(element.toJson()));
    FirebaseFirestore.instance.collection('comment').doc(idNews).collection(idNews).doc(comment.id).update({
      'listComment': listComment
    });
  }
}