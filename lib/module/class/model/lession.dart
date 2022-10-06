class Lession {
  Lession({
      this.lessionId, 
      this.idClassDetail, 
      this.nameLession, 
      this.status});

  Lession.fromJson(dynamic json) {
    lessionId = json['lessionId'];
    idClassDetail = json['idClassDetail'];
    nameLession = json['nameLession'];
    status = json['status'];
  }
  String? lessionId;
  String? idClassDetail;
  String? nameLession;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lessionId'] = lessionId;
    map['idClassDetail'] = idClassDetail;
    map['nameLession'] = nameLession;
    map['status'] = status;
    return map;
  }

}