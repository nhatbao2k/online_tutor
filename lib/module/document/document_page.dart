import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/module/document/document_detail_page.dart';
import 'package:online_tutor/module/document/document_product_page.dart';
import 'package:online_tutor/module/document/model/document.dart';
import 'package:online_tutor/module/document/presenter/document_product_presenter.dart';

import '../../common/common_function.dart';
import '../../common/image_load.dart';
import '../../languages/languages.dart';

class DocumentPage extends StatefulWidget {
  Map<String, dynamic>? _dataUser;

  DocumentPage(this._dataUser);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {

  Stream<QuerySnapshot>? _stream;
  DocumentProductPresenter? _presenter;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('documents').snapshots();
    _presenter = DocumentProductPresenter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: CommonColor.blue,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(appType: AppType.child, title: Languages.of(context).document),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return LoadingView();
                }else if(snapshot.hasError){
                  return NoDataView(Languages.of(context).noData);
                }else if(!snapshot.hasData){
                  return NoDataView(Languages.of(context).noData);
                }else{
                  return Wrap(
                    children: snapshot.data!.docs.map((e) {
                      Document doc = Document.fromJson(e.data());
                      return CommonKey.ADMIN==widget._dataUser!['role']||CommonKey.TEACHER==widget._dataUser!['role']
                      ?_itemDocumentAdmin(doc)
                          :_itemDocument(doc);
                    }).toList(),
                  );
                }
              },
            )
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: CommonKey.TEACHER==widget._dataUser!['role']||CommonKey.ADMIN==widget._dataUser!['role']?true:false,
        child: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>DocumentProductPage('', null))),
          child: Icon(
            Icons.add,
            color: CommonColor.white,
          ),
        ),
      ),
    );
  }
  
  Widget _itemDocument(Document document){
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>DocumentDetailPage(document))),
      child: Container(
        height: 220,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: checkLandscape(context)?getWidthDevice(context)/4:getWidthDevice(context)/2-16,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: CommonColor.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageLoad.imageNetwork('${document.imageLink}', 150, getWidthDevice(context)),
            SizedBox(height: 16,),
            CustomText('${document.name}', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
            CustomText('GV: ${document.teacher}', textStyle: TextStyle(color: CommonColor.black,  fontSize: 14, overflow: TextOverflow.ellipsis), maxline: 2),
          ],
        ),
      ),
    );
  }

  Widget _itemDocumentAdmin(Document document){
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>DocumentDetailPage(document))),
      child: Container(
        height: 270,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: checkLandscape(context)?getWidthDevice(context)/4:getWidthDevice(context)/2-16,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: CommonColor.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageLoad.imageNetwork('${document.imageLink}', 150, getWidthDevice(context)),
            SizedBox(height: 16,),
            CustomText('${document.name}', textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 2),
            CustomText('GV: ${document.teacher}', textStyle: TextStyle(color: CommonColor.black,  fontSize: 14, overflow: TextOverflow.ellipsis), maxline: 2),
            SizedBox(height: 4,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                      Icons.edit,
                    color: CommonColor.blue,
                  ),
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>DocumentProductPage(CommonKey.EDIT, document))),
                ),
                SizedBox(width: 8,),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: CommonColor.blue,
                  ),
                  onPressed: ()=>_presenter!.DeleteDoc(document),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
