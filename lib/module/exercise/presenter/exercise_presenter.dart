import 'package:cloud_firestore/cloud_firestore.dart';

import '../../lession/model/homework.dart';
import '../../lession/model/lession_detail.dart';
import '../../lession/model/qa.dart';

class ExercisePresenter{

  List<QA>initData(List<QA> listQA){
    List<QA> listQAResult = [];
    for(QA qa in listQA){
      qa.correct = false;
      listQAResult.add(qa);
    }
    return listQAResult;
  }

  List<QA> ResultSubmit(List<QA> listQA){
    List<QA> listQAResult = [];
    for(QA qa in listQA){
      if(qa.answer==qa.studentAnswer){
        qa.correct = true;
      }else{
        qa.correct = false;
      }
      listQAResult.add(qa);
    }
    return listQAResult;
  }

  int ScroreCorrect(List<QA> listQA){
     int totalCorrect = 0;
     for(QA qa in listQA){
       if(qa.correct==true){
         totalCorrect++;
       }
     }
     return totalCorrect;
  }
  double Score(List<QA> listQA){
    double total = 0.0;
    int totalCorect = ScroreCorrect(listQA);
    int lengthQA = listQA.length;
    total = totalCorect/lengthQA;
    return total;
  }

  void UpdateTotalLession(LessionDetail lessionDetail, List<Homework> listHomework){
    Map<String, dynamic> data = lessionDetail.toJson();
    FirebaseFirestore.instance.collection('lession_detail').doc(lessionDetail.idLessionDetail).set(data);
  }
}