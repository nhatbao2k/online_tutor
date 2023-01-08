// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TeacherPresenter on _TeacherPresenter, Store {
  late final _$stateAtom =
      Atom(name: '_TeacherPresenter.state', context: context);

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

  late final _$_TeacherPresenterActionController =
      ActionController(name: '_TeacherPresenter', context: context);

  @override
  void lookAccount(String id) {
    final _$actionInfo = _$_TeacherPresenterActionController.startAction(
        name: '_TeacherPresenter.lookAccount');
    try {
      return super.lookAccount(id);
    } finally {
      _$_TeacherPresenterActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
