import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/module/social/chat/model/user_chat.dart';

import '../../../../common/common_key.dart';
import '../model/chat_message.dart';

class ChatUserPresenter{
  void CreateUserChat(UserChat userChat, UserChat userChatFriend){
    Map<String, dynamic> data = userChat.toJson();
    Map<String, dynamic> dataFriend = userChatFriend.toJson();
    FirebaseFirestore.instance.collection('user_chat').doc(userChat.username).collection(userChat.username!).doc(userChatFriend.username!).set(dataFriend);
    FirebaseFirestore.instance.collection('user_chat').doc(userChatFriend.username).collection(userChatFriend.username!).doc(userChat.username!).set(data);
  }

  Future<bool> CreateChat({required String message, File? fileImage, required Map<String, dynamic> user, required Map<String, dynamic> userFriend})async{
    if(fileImage==null){
      _CreateChat(user, userFriend, '', message);
    }else{
      String link = '';
      final metadata = SettableMetadata(contentType: "image/jpeg");
      final storageRef = FirebaseStorage.instance.ref();
      String path = '${CommonKey.CHAT}/${user['phone']}/${userFriend['username']}/${getCurrentTime()}/.jpg';
      await storageRef
          .child("$path")
          .putFile(fileImage, metadata).whenComplete(() async{
        link = await getLinkStorage(path).then((value) => link=value);
        _CreateChat(user, userFriend, link, message);
      });
    }
    return true;
  }

  void _CreateChat(Map<String, dynamic> user, Map<String, dynamic> userFriend, String link, String message){
    ChatMessage chat = ChatMessage(
        message: message,
        avatar: user['avatar'],
        username: user['phone'],
        fullname: user['fullname'],
        linkImage: link,
        timestamp: getTimestamp(),
        usernameFriend: userFriend['username'],
        fullnameFriend: userFriend['fullname']
    );
    Map<String, dynamic> data = chat.toJson();
    FirebaseFirestore.instance.collection('chats').doc(user['phone']).collection(userFriend['username']).doc(getCurrentTime()).set(data);
    FirebaseFirestore.instance.collection('chats').doc(userFriend['username']).collection(user['phone']).doc(getCurrentTime()).set(data);
  }
}