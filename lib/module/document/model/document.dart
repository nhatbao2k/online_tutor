import 'document_file.dart';

class Document{
  String? id;
  String? imageLink;
  String? name;
  String? teacher;
  String? creatUser;
  List<DocumentFile>? listDocument;


  Document({this.id, this.imageLink, this.name, this.listDocument, this.teacher, this.creatUser});

  Document.fromJson(dynamic json) {
    id = json['id'];
    imageLink = json['imageLink'];
    name = json['name'];
    teacher = json['teacher'];
    creatUser = json['createUser'];
    if (json['listDocument'] != null) {
      listDocument = [];
      json['listDocument'].forEach((v) {
        listDocument!.add(DocumentFile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['imageLink'] = imageLink;
    map['name'] = name;
    map['teacher']=teacher;
    map['createUser'] = creatUser;
    if (listDocument != null) {
      map['listDocument'] = listDocument!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}