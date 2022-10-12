
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/module/pdf_view/pdf_view.dart';

class PdfViewerPage extends StatelessWidget{
  String? _url;

  PdfViewerPage(this._url);

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
