import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:online_tutor/common/single_state.dart';

import '../../class/model/lession.dart';
import '../model/lession_detail.dart';

part 'lession_admin_presenter.g.dart';
class LessionAdminPresenter = _LessionAdminPresenter with _$LessionAdminPresenter;

abstract class _LessionAdminPresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;

  LessionDetail? detail;
  @action
  Future getLessionDetail(Lession lession) async{
    state = SingleState.LOADING;
    await FirebaseFirestore.instance.collection('lession_detail').doc(lession.lessionId).get().then((value) {
      if(value.exists){
        detail = LessionDetail.fromJson(value.data());
        if(detail!=null){
          state = SingleState.HAS_DATA;
        }else{
          state = SingleState.NO_DATA;
        }

      }else{
        state = SingleState.NO_DATA;

      }
    }).catchError((onError) {
    state = SingleState.NO_DATA;});

  }
}