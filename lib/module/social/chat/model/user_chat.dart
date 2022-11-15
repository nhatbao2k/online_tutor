import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat{
  String? username;
  String? fullname;
  String? avatar;
  bool? isOnline;
  Timestamp? timestamp;

  UserChat(
      {this.username,
      this.fullname,
      this.avatar,
      this.isOnline,
      this.timestamp});

  UserChat.fromJson(dynamic json) {
    username = json['username'];
    fullname = json['fullname'];
    avatar = json['avatar'];
    isOnline = json['isOnline'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['fullname'] = fullname;
    map['avatar'] = avatar;
    map['isOnline']=isOnline;
    map['timestamp']=timestamp;

    return map;
  }
}