import 'package:online_tutor/module/lession/model/qa.dart';

class Homework {
  Homework({
      this.idHomework, 
      this.answer, 
      this.question, 
      this.worksheet, 
      this.listQuestion,
      this.totalQA});

  Homework.fromJson(dynamic json) {
    idHomework = json['idHomework'];
    answer = json['answer'];
    question = json['question'];
    worksheet = json['worksheet'];
    totalQA = json['totalQA'];
    if (json['listQuestion'] != null) {
      listQuestion = [];
      json['listQuestion'].forEach((v) {
        listQuestion!.add(QA.fromJson(v));
      });
    }
  }
  String? idHomework;
  String? answer;
  String? question;
  bool? worksheet;
  List<QA>? listQuestion;
  double? totalQA;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idHomework'] = idHomework;
    map['answer'] = answer;
    map['question'] = question;
    map['worksheet'] = worksheet;
    map['totalQA'] = totalQA;
    if (listQuestion != null) {
      map['listQuestion'] = listQuestion!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}