import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/custom_drop_down_box.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:online_tutor/module/lession/model/discuss.dart';
import 'package:online_tutor/module/lession/model/homework.dart';
import 'package:online_tutor/module/lession/model/lession_detail.dart';
import 'package:online_tutor/module/lession/model/qa.dart';
import 'package:online_tutor/module/lession/presenter/lession_product_presenter.dart';
import 'package:online_tutor/storage/shared_preferences.dart';

import '../../common/common_theme.dart';
import '../class/model/class_course.dart';
import '../class/model/lession.dart';
import '../class/model/my_class.dart';
import '../class/model/my_class_detail.dart';
class LessionProductPage extends StatefulWidget {
  Lession? _lession;
  MyClassDetail? _myClassDetail;
  ClassCourse? _course;
  MyClass? _myClass;
  String? _keyFlow;
  LessionDetail? _lessionDetail;

  LessionProductPage(this._lession, this._keyFlow, this._course, this._myClass, this._myClassDetail, this._lessionDetail);

  @override
  State<LessionProductPage> createState() => _LessionProductPageState(_lession, _keyFlow, _course, _myClass, _myClassDetail, _lessionDetail);
}

class _LessionProductPageState extends State<LessionProductPage> {
  Lession? _lession;
  String? _keyFlow;
  MyClassDetail? _myClassDetail;
  ClassCourse? _course;
  MyClass? _myClass;
  LessionDetail? _lessionDetail;
  _LessionProductPageState(this._lession, this._keyFlow, this._course, this._myClass, this._myClassDetail, this._lessionDetail);

  LessionProductPresenter? _presenter;
  String _fileNameContent = '';
  String _fileContent = '';
  String _videoLink = '';
  String _fileNameQuestion = '';
  String _fileQuestion = '';
  String _fileAnswer = '';
  String _fileNameAnswer = '';
  List<Homework> _homeworkList = [Homework(idHomework: '1',listQuestion: [QA(id: '1')], worksheet: true, totalQA: 0.0)];
  List<String> _stringList = ['Có trắc nghiệm', 'Không trắc nghiệm'];
  String _select = '';
  String _fullname = '';
  String _avatar = '';
  TextEditingController _controllerUrlLink = TextEditingController();

  @override
  void initState() {
    _presenter = LessionProductPresenter();
    _select = _stringList[0];
    getDataUser();
    if(CommonKey.EDIT==_keyFlow){
      getDataEdit();
    }
  }

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
            if(_videoLink.isEmpty){
              CustomDialog(context: context, content: 'chưa có link');
            }else if(_fileContent.isEmpty){
              CustomDialog(context: context, content: 'chưa có file nội dung');
            }else if(_fileAnswer.isEmpty){
              CustomDialog(context: context, content: 'Chưa có file đáp án');
            }else if(_fileQuestion.isEmpty){
              CustomDialog(context: context, content: 'Chưa có file câu hỏi');
            }else{
              if(CommonKey.EDIT!=_keyFlow){
                Discuss? discuss = Discuss(name: _fullname, avatar: _avatar, timeStamp: getTimestamp(), content: Languages.of(context).youNeed, nameFeedback: '');
                LessionDetail lessionDetail = LessionDetail(idLessionDetail: replaceSpace(_lession!.lessionId!), fileContent: _fileContent,
                    nameLession: _lession!.nameLession!, videoLink: _videoLink, homework: _homeworkList, discuss: [discuss]);
                showLoaderDialog(context);
                _presenter!.CreateLessionDetail(lessionDetail).then((value){
                  listenStatus(context, value);
                });
              }else{
                LessionDetail lessionDetail = LessionDetail(idLessionDetail: replaceSpace(_lession!.lessionId!), fileContent: _fileContent,
                    nameLession: _lession!.nameLession!, videoLink: _videoLink, homework: _homeworkList);
                showLoaderDialog(context);
                _presenter!.updateLessionDetail(lessionDetail).then((value){
                  listenStatus(context, value);
                });
              }

            }

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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomText('File nội dung: $_fileNameContent'),
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
                              _fileNameContent = fileName;
                              final File fileForFirebase = File(file.path!);
                              _fileContent = await _presenter!.UploadFilePdf(fileForFirebase, _myClassDetail, _course, _myClass, fileName).then((value) {
                                Navigator.pop(context);
                                if(value.isEmpty){
                                  showToast(Languages.of(context).onFailure);
                                }
                                return value;
                              });
                              setState(()=>null);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      decoration: CommonTheme.textFieldInputDecoration(labelText: Languages.of(context).linkExercise, hintText: Languages.of(context).linkExercise),
                      onChanged: (value)=>setState(()=> _videoLink=value),
                      controller: _controllerUrlLink,
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
                          child: CustomText('${Languages.of(context).fileQuestion}: $_fileNameQuestion'),
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
                              _fileNameQuestion = fileName;
                              final File fileForFirebase = File(file.path!);
                              _fileQuestion = await _presenter!.UploadFilePdf(fileForFirebase, _myClassDetail, _course, _myClass, fileName).then((value) {
                                Navigator.pop(context);
                                if(value.isEmpty){
                                  showToast(Languages.of(context).onFailure);
                                }
                                return value;
                              });
                              _homeworkList[0].question=_fileQuestion;
                              setState(()=>null);
                            }
                          },
                        )
                      ],
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
                          child: CustomText('${Languages.of(context).fileAnswer}: $_fileNameAnswer'),
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
                              _fileNameAnswer = fileName;
                              final File fileForFirebase = File(file.path!);
                              _fileAnswer = await _presenter!.UploadFilePdf(fileForFirebase, _myClassDetail, _course, _myClass, fileName).then((value) {
                                Navigator.pop(context);
                                if(value.isEmpty){
                                  showToast(Languages.of(context).onFailure);
                                }
                                return value;
                              });
                              _homeworkList[0].answer=_fileAnswer;
                              setState(()=>null);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomDropDownBox(
                      value: _select,
                      itemsList: _stringList,
                      onChanged: (value){
                        _select = value;
                        if(_select!='Có trắc nghiệm'){
                          _homeworkList[0].listQuestion=null;
                          _homeworkList[0].worksheet=false;
                        }else{
                          _homeworkList[0] = Homework(idHomework: '1',listQuestion: [QA(id: '1')]);
                          _homeworkList[0].worksheet=true;
                        }
                        setState(()=>null);
                      },
                    ),
                  ),
                  _select=='Có trắc nghiệm'
                      ?Wrap(
                    children:  List.generate(_homeworkList[0].listQuestion!.length, (index) => _itemWorkSheet(_homeworkList[0].listQuestion![index], index)),
                      ):SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemWorkSheet(QA qa, int index){
    String question='';
    String answer='';
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(labelText: CommonKey.EDIT==_keyFlow?qa.question:Languages.of(context).question, hintText: CommonKey.EDIT==_keyFlow?qa.question:Languages.of(context).question),
              onChanged: (value)=>setState(()=> qa.question=value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: CommonTheme.textFieldInputDecoration(labelText: CommonKey.EDIT==_keyFlow?qa.answer:Languages.of(context).answer, hintText: CommonKey.EDIT==_keyFlow?qa.answer:Languages.of(context).answer),
              onChanged: (value)=>setState(()=> qa.answer=value),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 8,),
              ButtonIcon(Icons.add, (data) {
                _homeworkList[0].listQuestion!.add(QA(id: '${index+2}'));
                setState((){

                });
              }),
              ButtonIcon(Icons.delete, (data) {
                _homeworkList[0].listQuestion!.remove(qa);
                setState((){
                });
              }),
              SizedBox(width: 8,)
            ],
          )
        ],
      ),
    );
  }

  Future<void> getDataUser() async{
    Map<String, dynamic> data;
    dynamic user = await SharedPreferencesData.GetData(CommonKey.USER);
    data = jsonDecode(user.toString());
    _fullname = data['fullname'];
    _avatar = data['avatar'];
  }

  Future<void> getDataEdit() async{
    _fileNameAnswer = _lessionDetail!.homework![0].answer!;
    _fileAnswer = _fileNameAnswer;
    _fileNameQuestion = _lessionDetail!.homework![0].question!;
    _fileQuestion = _fileNameQuestion;
    _fileContent = _lessionDetail!.fileContent!;
    _fileNameContent = _fileContent;
    _videoLink = _lessionDetail!.videoLink!;
    _homeworkList[0].question=_fileQuestion;
    _homeworkList[0].answer=_fileAnswer;
    _homeworkList[0].listQuestion=_lessionDetail!.homework![0].listQuestion;
    _controllerUrlLink = TextEditingController(text: _videoLink);
    setState(()=>null);
  }
}
