class ClassCourse{
  String? _idCourse;
  String? _idTeacher;
  String? _nameTeacher;
  String? _nameCourse;

  ClassCourse(this._idCourse, this._idTeacher, this._nameTeacher, this._nameCourse);

  String? get getNameTeacher => _nameTeacher;

  String? get getIdTeacher => _idTeacher;

  String? get getIdCourse => _idCourse;

  String? get getNameCourse => _nameCourse;
}