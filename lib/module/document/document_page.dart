import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/module/document/document_product_page.dart';

import '../../languages/languages.dart';

class DocumentPage extends StatefulWidget {
  Map<String, dynamic>? _dataUser;

  DocumentPage(this._dataUser);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
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
            child: SingleChildScrollView(
              child: Text('hello'),
            ),
          )
        ],
      ),
      floatingActionButton: Visibility(
        visible: CommonKey.ADMIN==widget._dataUser!['role']||CommonKey.ADMIN==widget._dataUser!['role']?true:false,
        child: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>DocumentProductPage(''))),
          child: Icon(
            Icons.add,
            color: CommonColor.white,
          ),
        ),
      ),
    );
  }
}
