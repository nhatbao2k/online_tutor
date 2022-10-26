import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    this.id,
    this.name,
    this.avatar,
    this.content,
    this.imageLink,
    this.timeStamp,
    this.nameFeedback,
    this.level,
    this.listComment,
    this.idUser});

  Comment.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    content = json['content'];
    imageLink = json['imageLink'];
    timeStamp = json['timeStamp'];
    idUser = json['idUser'];
    nameFeedback = json['nameFeedback'];
    level = json['level'];
    if (json['listComment'] != null) {
      listComment = [];
      json['listComment'].forEach((v) {
        listComment!.add(Comment.fromJson(v));
      });
    }
  }

  String? id;
  String? idUser;
  String? name;
  String? avatar;
  String? content;
  String? imageLink;
  String? nameFeedback;
  String? level;
  Timestamp? timeStamp;
  List<Comment>? listComment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['avatar'] = avatar;
    map['content'] = content;
    map['imageLink'] = imageLink;
    map['timeStamp'] = timeStamp;
    map['nameFeedback'] = nameFeedback;
    map['level'] = level;
    map['idUser'] = idUser;
    if (listComment != null) {
      map['listComment'] = listComment!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}