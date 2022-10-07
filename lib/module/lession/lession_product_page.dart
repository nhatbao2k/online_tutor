import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/model/Lession.dart';
import 'package:file_picker/file_picker.dart';
class LessionProductPage extends StatefulWidget {
  Lession? _lession;
  String? _keyFlow;

  LessionProductPage(this._lession, this._keyFlow);

  @override
  State<LessionProductPage> createState() => _LessionProductPageState(_lession, _keyFlow);
}

class _LessionProductPageState extends State<LessionProductPage> {
  Lession? _lession;
  String? _keyFlow;

  _LessionProductPageState(this._lession, this._keyFlow);

  String fileContent = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(appType: AppType.childFunction, title: _lession!.nameLession!, nameFunction: Languages.of(context).createNew, callback: (value){

          },),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomText('File nội dung: $fileContent'),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_circle_up_sharp),
                          color: CommonColor.blue,
                          onPressed: () async{
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if(result!=null){
                              PlatformFile file = result.files.first;
                              String fileName = result.files.first.name;
                              fileContent = fileName;

                              setState(()=>null);
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
