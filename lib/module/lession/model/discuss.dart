import 'package:cloud_firestore/cloud_firestore.dart';

class Discuss {
  Discuss({
      this.name, 
      this.avatar, 
      this.content, 
      this.imageLink, 
      this.timeStamp,
      this.nameFeedback});

  Discuss.fromJson(dynamic json) {
    name = json['name'];
    avatar = json['avatar'];
    content = json['content'];
    imageLink = json['imageLink'];
    timeStamp = json['timeStamp'];
    nameFeedback = json['nameFeedback'];
  }

  String? name;
  String? avatar;
  String? content;
  String? imageLink;
  String? nameFeedback;
  Timestamp? timeStamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['avatar'] = avatar;
    map['content'] = content;
    map['imageLink'] = imageLink;
    map['timeStamp'] = timeStamp;
    map['nameFeedback'] = nameFeedback;
    return map;
  }

}