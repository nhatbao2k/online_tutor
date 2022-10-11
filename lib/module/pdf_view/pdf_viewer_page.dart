
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/module/pdf_view/pdf_view.dart';

class PdfViewerPage extends StatefulWidget{
  String? _url;

  PdfViewerPage(this._url);

  @override
  State<StatefulWidget> createState() =>_PdfViewerPage(_url);
}

class _PdfViewerPage extends State<PdfViewerPage>{
  String? _url;

  _PdfViewerPage(this._url);

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: PDFViewerFromUrl(url: _url!),
    );
  }

}