import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_tutor/module/social/chat/model/user_chat.dart';

class ChatUserPresenter{
  void CreateUserChat(UserChat userChat, UserChat userChatFriend){
    Map<String, dynamic> data = userChat.toJson();
    Map<String, dynamic> dataFriend = userChatFriend.toJson();
    FirebaseFirestore.instance.collection('user_chat').doc(userChat.username).collection(userChatFriend.username!).doc(userChatFriend.username!).set(dataFriend);
    FirebaseFirestore.instance.collection('user_chat').doc(userChatFriend.username).collection(userChat.username!).doc(userChat.username!).set(data);
  }
}