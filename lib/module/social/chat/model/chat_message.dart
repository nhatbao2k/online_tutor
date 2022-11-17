import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage{
  String? message;
  String? linkImage;
  String? username;
  String? fullname;
  String? usernameFriend;
  String? fullnameFriend;
  Timestamp? timestamp;
  String? avatar;

  ChatMessage(
      {this.message,
      this.linkImage,
      this.username,
      this.fullname,
      this.usernameFriend,
      this.fullnameFriend,
      this.timestamp,
      this.avatar});

  ChatMessage.fromJson(dynamic json) {
    username = json['username'];
    fullname = json['fullname'];
    avatar = json['avatar'];
    message = json['message'];
    timestamp = json['timestamp'];
    usernameFriend = json['usernameFriend'];
    fullnameFriend = json['fullnameFriend'];
    linkImage = json['linkImage'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['fullname'] = fullname;
    map['avatar'] = avatar;
    map['message']=message;
    map['timestamp']=timestamp;
    map['usernameFriend']=usernameFriend;
    map['fullnameFriend']=fullnameFriend;
    map['linkImage']=linkImage;
    return map;
  }
}