// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_presenter.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SchedulePresenter on _SchedulePresenter, Store {
  late final _$stateAtom =
      Atom(name: '_SchedulePresenter.state', context: context);

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

  late final _$getScheduleAsyncAction =
      AsyncAction('_SchedulePresenter.getSchedule', context: context);

  @override
  Future<List<MyClass>> getSchedule(String idTeacher, String role) {
    return _$getScheduleAsyncAction
        .run(() => super.getSchedule(idTeacher, role));
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
