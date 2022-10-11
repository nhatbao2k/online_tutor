// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lession_admin_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LessionAdminPresenter on _LessionAdminPresenter, Store {
  late final _$stateAtom =
      Atom(name: '_LessionAdminPresenter.state', context: context);

  @override
  SingleState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(SingleState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getLessionDetailAsyncAction =
      AsyncAction('_LessionAdminPresenter.getLessionDetail', context: context);

  @override
  Future<dynamic> getLessionDetail(Lession lession) {
    return _$getLessionDetailAsyncAction
        .run(() => super.getLessionDetail(lession));
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
