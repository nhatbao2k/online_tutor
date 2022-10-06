import 'package:mobx/mobx.dart';
import 'package:online_tutor/common/single_state.dart';

part 'class_detail_admin_presenter.g.dart';

class ClassDetailAdminPresenter = _ClassDetailAdminPresenter with _$ClassDetailAdminPresenter;
abstract class _ClassDetailAdminPresenter with Store{
  @observable
  SingleState state = SingleState.LOADING;

  @action
  Future loadData(bool value) async{
    state = SingleState.LOADING;
    bool result = await value;
    if(result){
      state = SingleState.HAS_DATA;
    }else{
      state = SingleState.NO_DATA;
    }
  }
}