class MyClass{
  String? idClass;
  String? idCourse;
  String? idTeacher;
  String? teacherName;
  String? status;
  String? startDate;
  String? price;
  String? nameClass;
  String? describe;
  String? startHours;
  String? imageLink;
  List<String>? subscribe;

  MyClass(
      {this.idClass,
      this.idCourse,
      this.idTeacher,
      this.teacherName,
      this.status,
      this.startDate,
      this.price,
      this.nameClass,
      this.describe,
      this.startHours,
      this.subscribe});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCourse'] = idCourse;
    map['idTeacher'] = idTeacher;
    map['imageLink'] = imageLink;
    map['nameClass'] = nameClass;
    map['price'] = price;
    map['startDate'] = startDate;
    map['startHours'] = startHours;
    map['status'] = status;
    map['subscribe'] = subscribe;
    map['teacherName'] = teacherName;
    return map;
  }

  MyClass.fromJson(dynamic json) {
    idClass = json['idClass'];
    idCourse = json['idCourse'];
    idTeacher = json['idTeacher'];
    status = json['status'];
    teacherName = json['teacherName'];
    startDate = json['startDate'];
    price = json['price'];
    nameClass = json['nameClass'];
    describe = json['describe'];
    startHours = json['startHours'];
    imageLink = json['imageLink'];
    subscribe = json['subscribe'] != null ? json['subscribe'].cast<String>() : [];
  }
}