class DocumentFile{
  String? id;
  String? nameFile;
  String? linkeFile;

  DocumentFile({this.id, this.nameFile, this.linkeFile});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nameFile'] = nameFile;
    map['linkeFile'] = linkeFile;
    return map;
  }

  DocumentFile.fromJson(dynamic json) {
    id = json['id'];
    nameFile = json['nameFile'];
    linkeFile = json['linkeFile'];
  }
}