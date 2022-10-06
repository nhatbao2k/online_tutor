// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_detail_admin_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ClassDetailAdminPresenter on _ClassDetailAdminPresenter, Store {
  late final _$stateAtom =
      Atom(name: '_ClassDetailAdminPresenter.state', context: context);

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

  late final _$loadDataAsyncAction =
      AsyncAction('_ClassDetailAdminPresenter.loadData', context: context);

  @override
  Future<dynamic> loadData(bool value) {
    return _$loadDataAsyncAction.run(() => super.loadData(value));
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
