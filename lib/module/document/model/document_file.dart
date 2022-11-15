class DocumentFile{
  String? id;
  String? nameFile;
  String? linkFile;

  DocumentFile({this.id, this.nameFile, this.linkFile});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['nameFile'] = nameFile;
    map['linkFile'] = linkFile;
    return map;
  }

  DocumentFile.fromJson(dynamic json) {
    id = json['id'];
    nameFile = json['nameFile'];
    linkFile = json['linkFile'];
  }
}