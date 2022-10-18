import 'package:cloud_firestore/cloud_firestore.dart';

import '../module/class/model/class_course.dart';

class DashBoardPresenter{
  ClassCourse? course;
  Future<ClassCourse> getCourse(String idUser) async{
    course=ClassCourse('', '', '', '');
    await FirebaseFirestore.instance.collection('course').where('subscribe', arrayContains: idUser).get().then((value) {
      value.docs.forEach((element) {
        course = ClassCourse(element['idCourse'], element['idTeacher'], element['teacherName'], element['name']);
      });
    });
    print(course);
    return course!;
  }
}