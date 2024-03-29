import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/single_state.dart';
import 'package:online_tutor/module/class/model/class_course.dart';

import '../../class/model/my_class.dart';
part 'schedule_presenter.g.dart';

class SchedulePresenter = _SchedulePresenter with _$SchedulePresenter;
abstract class _SchedulePresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;

  List<MyClass> listMon = [];
  List<MyClass> listTue = [];
  List<MyClass> listWeb = [];
  List<MyClass> listThu = [];
  List<MyClass> listFri = [];
  List<MyClass> listSat = [];
  List<MyClass> listSun = [];
  List<MyClass> listMyClass = [];
  List<ClassCourse> listCours = [];
  @action
  Future<List<MyClass>> getSchedule(String idTeacher, String role) async{
    state = SingleState.LOADING;
    List<MyClass> myClass=[];
    if(CommonKey.TEACHER==role){
      await FirebaseFirestore.instance.collection('class').where('idTeacher', isEqualTo:idTeacher).get().then((value) {
        value.docs.forEach((element) {
          MyClass myCla = MyClass.fromJson(element.data());
          myClass.add(myCla);
        });
        if(myClass.length>0){
          _mapDataDay(myClass);
          listMyClass=myClass;
          state = SingleState.HAS_DATA;
        }else{
          state = SingleState.NO_DATA;
        }
        return myClass;
      }).catchError((onError){
        state = SingleState.NO_DATA;
        throw(onError);
      });
    }else{
      await FirebaseFirestore.instance.collection('class').where('subscribe', arrayContains:idTeacher).get().then((value) {
        value.docs.forEach((element) {
          MyClass myCla = MyClass.fromJson(element.data());
          myClass.add(myCla);
        });
        if(myClass.length>0){
          _mapDataDay(myClass);
          listMyClass=myClass;
          state = SingleState.HAS_DATA;
        }else{
          state = SingleState.NO_DATA;
        }
        return myClass;
      }).catchError((onError){
        state = SingleState.NO_DATA;
        throw(onError);
      });
    }
    return myClass;
  }
  
  void _mapDataDay(List<MyClass> myClass){
    listMon = myClass.where((element) => CommonKey.MON==element.startDate).toList();
    listTue = myClass.where((element) => CommonKey.TUE==element.startDate).toList();
    listWeb = myClass.where((element) => CommonKey.WED==element.startDate).toList();
    listThu = myClass.where((element) => CommonKey.THU==element.startDate).toList();
    listFri = myClass.where((element) => CommonKey.FRI==element.startDate).toList();
    listSat = myClass.where((element) => CommonKey.SAT==element.startDate).toList();
    listSun = myClass.where((element) => CommonKey.SUN==element.startDate).toList();
  }
  
  Future getCourse(String _role, String username) async{
    await FirebaseFirestore.instance.collection('course').where('idTeacher', isEqualTo: username).get().then((value){
      ClassCourse course;
      value.docs.forEach((element) {
        course = ClassCourse(element['idCourse'], element['idTeacher'], element['teacherName'], element['name']);
        listCours.add(course);
      });
    });
  }

  ClassCourse getModelCourse(String idCourse){
    List<ClassCourse> course = listCours.where((element) => element.getIdCourse==idCourse).toList();
    return course[0];
  }
}