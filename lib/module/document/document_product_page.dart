import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/document/presenter/document_product_presenter.dart';

import '../../common/common_color.dart';
import '../../common/common_key.dart';
import '../../common/common_theme.dart';
import '../../common/common_widget.dart';
import '../../common/image_load.dart';
import '../../res/images/image_view.dart';
import 'model/document_file.dart';

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
  List<DocumentFile> _documentList = [DocumentFile()];
  DocumentProductPresenter? _presenter;


  @override
  void initState() {
    _presenter = DocumentProductPresenter();
  }

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
                  ListView.separated(
                    itemBuilder: (context, index)=>_itemDocument(_documentList[index]),
                    itemCount: _documentList.length,
                    separatorBuilder: (context, index)=>SizedBox(height: 8,),
                  ),
                  ButtonIcon(Icons.add, (data) => setState(()=>_documentList.add(DocumentFile()))),
                ],
              )
            ),
          )
        ],
      ),
    );
  }

  Widget _itemDocument(DocumentFile documentFile){
    return   Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
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
                    _presenter!.UploadFilePdf(fileForFirebase, fileName).then((value) {
                      if(value.isNotEmpty){
                        documentFile.id = getCurrentTime();
                        documentFile.linkeFile=value;
                        documentFile.nameFile=fileName;
                      }
                      setState(()=>null);
                    });
                  }
                },
              )
            ],
          ),
          ButtonIcon(Icons.delete, (data) => setState(()=>_documentList.remove(documentFile)))
        ],
      ),
    );
  }
}
