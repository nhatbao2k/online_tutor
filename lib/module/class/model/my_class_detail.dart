

import 'lession.dart';

class MyClassDetail {
  MyClassDetail({
      this.idClassDetail, 
      this.idClass, 
      this.teacherName, 
      this.imageLink, 
      this.nameClass, 
      this.describe, 
      this.lession,});

  MyClassDetail.fromJson(dynamic json) {
    idClassDetail = json['idClassDetail'];
    idClass = json['idClass'];
    teacherName = json['teacherName'];
    imageLink = json['imageLink'];
    nameClass = json['nameClass'];
    describe = json['describe'];
    if (json['lession'] != null) {
      lession = [];
      json['lession'].forEach((v) {
        lession!.add(Lession.fromJson(v));
      });
    }
  }
  String? idClassDetail;
  String? idClass;
  String? teacherName;
  String? imageLink;
  String? nameClass;
  String? describe;
  List<Lession>? lession;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idClassDetail'] = idClassDetail;
    map['idClass'] = idClass;
    map['teacherName'] = teacherName;
    map['imageLink'] = imageLink;
    map['nameClass'] = nameClass;
    map['describe'] = describe;
    if (lession != null) {
      map['lession'] = lession!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}