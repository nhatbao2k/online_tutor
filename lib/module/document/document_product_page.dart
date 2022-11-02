import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';

import '../../common/common_color.dart';
import '../../common/common_key.dart';
import '../../common/common_theme.dart';
import '../../common/common_widget.dart';
import '../../common/image_load.dart';
import '../../res/images/image_view.dart';

class DocumentProductPage extends StatefulWidget {
  String? _keyFlow;

  DocumentProductPage(this._keyFlow);

  @override
  State<DocumentProductPage> createState() => _DocumentProductPageState();
}

class _DocumentProductPageState extends State<DocumentProductPage> {

  File? _fileImage;
  String _imageLink='';
  String _nameDocument='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(appType: AppType.childFunction, title: Languages.of(context).documentNews, nameFunction: Languages.of(context).createNew, callback: (value){

          },),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => cropImage(context,(p0) => setState(()=>_fileImage=p0!), ''),
                    child: Center(child: _fileImage!=null?Image(image: FileImage(_fileImage!),width: 150, height: 150,):(_imageLink.isNotEmpty&&CommonKey.EDIT==widget._keyFlow!)?ImageLoad.imageNetwork(_imageLink, 150, 150):Image.asset(ImageView.chose_image, width: 150, height: 150,)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).nameClass, hintText: Languages.of(context).nameClass),
                      onChanged: (value)=>setState(()=> _nameDocument=value),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomText('File nội dung: '),
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
                              showLoaderDialog(context);
                              PlatformFile file = result.files.first;
                              String fileName = result.files.first.name;

                              final File fileForFirebase = File(file.path!);

                              setState(()=>null);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}
