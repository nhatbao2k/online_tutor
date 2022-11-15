import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/document/model/document.dart';
import 'package:online_tutor/module/document/model/document_file.dart';
import 'package:online_tutor/module/pdf_view/pdf_view.dart';

class DocumentDetailPage extends StatefulWidget {
  Document? _document;

  DocumentDetailPage(this._document);

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(appType: AppType.child, title: widget._document!.name!),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageLoad.imageNetwork(widget._document!.imageLink, getHeightDevice(context)*0.3, getWidthDevice(context)),
                SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText('${Languages.of(context).teacher}: ${widget._document!.teacher}', textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
                ),
                Divider(),
                SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: List.generate(widget._document!.listDocument!.length, (index) => _itemDoc(widget._document!.listDocument![index])),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemDoc(DocumentFile doc){
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>PDFViewerFromUrl(url: doc.linkFile!), )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.document_scanner,
                color: CommonColor.blue,
              ),
              SizedBox(width: 4,),
              Expanded(child: CustomText(doc.nameFile!, textStyle: TextStyle(fontSize: 12, color: CommonColor.blue, overflow: TextOverflow.ellipsis), maxline: 1)),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
