// class A {
//   A({
//       this.idCourse,
//       this.idTeacher,
//       this.imageLink,
//       this.nameClass,
//       this.price,
//       this.startDate,
//       this.startHours,
//       this.status,
//       this.subscribe,
//       this.teacherName,});
//
//   A.fromJson(dynamic json) {
//     idCourse = json['idCourse'];
//     idTeacher = json['idTeacher'];
//     imageLink = json['imageLink'];
//     nameClass = json['nameClass'];
//     price = json['price'];
//     startDate = json['startDate'];
//     startHours = json['startHours'];
//     status = json['status'];
//     subscribe = json['subscribe'] != null ? json['subscribe'].cast<String>() : [];
//     teacherName = json['teacherName'];
//   }
//   String idCourse;
//   String idTeacher;
//   String imageLink;
//   String nameClass;
//   String price;
//   String startDate;
//   String startHours;
//   String status;
//   List<String> subscribe;
//   String teacherName;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['idCourse'] = idCourse;
//     map['idTeacher'] = idTeacher;
//     map['imageLink'] = imageLink;
//     map['nameClass'] = nameClass;
//     map['price'] = price;
//     map['startDate'] = startDate;
//     map['startHours'] = startHours;
//     map['status'] = status;
//     map['subscribe'] = subscribe;
//     map['teacherName'] = teacherName;
//     return map;
//   }
//
// }