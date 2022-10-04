import 'package:cloud_firestore/cloud_firestore.dart';

class CoursePresenter{
  void deleteCourse(String idCourse){
    FirebaseFirestore.instance.collection('course').doc(idCourse).delete();

  }
}