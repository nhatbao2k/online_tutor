import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import '../../../common/single_state.dart';
part 'teacher_presenter.g.dart';

class TeacherPresenter = _TeacherPresenter with _$TeacherPresenter;
abstract class _TeacherPresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;

  @action
  void lookAccount(String id) {
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'isLooked': true
    }).whenComplete(() => state=SingleState.HAS_DATA);
  }
}