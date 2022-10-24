
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/exercise/exercise_page.dart';
import 'package:online_tutor/module/pdf_view/pdf_view.dart';

import '../lession/model/lession_detail.dart';
import '../lession/model/qa.dart';

class PdfViewerPage extends StatelessWidget{
  String? _url;
  List<QA>? _listQA;
  LessionDetail? _lessionDetail;
  PdfViewerPage(this._url, this._listQA, this._lessionDetail);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Stack(
        children: [
          PDFViewerFromUrl(url: _url!),
          _listQA==null||_lessionDetail==null?SizedBox():Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonDefault(Languages.of(context).exercise, (data) {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ExercisePage(_listQA, _lessionDetail)));
              }),
            ),
          )
        ],
      ),
    );
  }


}
