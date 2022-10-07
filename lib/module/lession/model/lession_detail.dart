import 'package:online_tutor/module/lession/model/Homework.dart';

import 'Discuss.dart';

class LessionDetail {
  LessionDetail({
      this.idLessionDetail, 
      this.nameLession, 
      this.fileContent, 
      this.videoLink,
      this.homework,
      this.discuss});

  LessionDetail.fromJson(dynamic json) {
    idLessionDetail = json['idLessionDetail'];
    nameLession = json['nameLession'];
    fileContent = json['fileContent'];
    videoLink = json['videoLink'];
    if (json['homework'] != null) {
      homework = [];
      json['homework'].forEach((v) {
        homework!.add(Homework.fromJson(v));
      });
    }
    if (json['discuss'] != null) {
      discuss = [];
      json['discuss'].forEach((v) {
        discuss!.add(Discuss.fromJson(v));
      });
    }
  }
  String? idLessionDetail;
  String? nameLession;
  String? fileContent;
  String? videoLink;
  List<Homework>? homework;
  List<Discuss>? discuss;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idLessionDetail'] = idLessionDetail;
    map['nameLession'] = nameLession;
    map['fileContent'] = fileContent;
    map['videoLink'] = videoLink;
    if (homework != null) {
      map['homework'] = homework!.map((v) => v.toJson()).toList();
    }
    if (discuss != null) {
      map['discuss'] = discuss!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}