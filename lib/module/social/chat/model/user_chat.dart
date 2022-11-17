import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat{
  String? username;
  String? fullname;
  String? userAvatar;
  bool? isOnline;
  Timestamp? timestamp;

  UserChat(
      {this.username,
      this.fullname,
      this.userAvatar,
      this.isOnline,
      this.timestamp});

  UserChat.fromJson(dynamic json) {
    username = json['username'];
    fullname = json['fullname'];
    userAvatar = json['userAvatar'];
    isOnline = json['isOnline'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['fullname'] = fullname;
    map['userAvatar'] = userAvatar;
    map['isOnline']=isOnline;
    map['timestamp']=timestamp;

    return map;
  }
}