import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/class_add_page.dart';
import 'package:online_tutor/module/class/presenter/class_add_presenter.dart';

import 'model/class_course.dart';

class ClassPage extends StatefulWidget {
  final ClassCourse? _course;
  ClassPage(this._course);

  @override
  State<ClassPage> createState() => _ClassPageState(_course);
}

class _ClassPageState extends State<ClassPage> {
  final ClassCourse? _course;
  _ClassPageState(this._course);
  Stream<QuerySnapshot>? _stream;
  ClassAddPresenter? _presenter;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('class').snapshots();
    _presenter = ClassAddPresenter();
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
          CustomAppBar(appType: AppType.child, title: Languages.of(context).myClass),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return LoadingView();
                      }else if(snapshot.hasError){
                        return NoDataView(Languages.of(context).noData);
                      }else{
                        return Wrap(
                          children:snapshot.data!.docs.map((e) {
                            Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
                            return itemCourse(context, data['nameClass'], data['teacherName'], data['imageLink'],
                                    (onClickEdit) => Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassAddPage(_course, CommonKey.EDIT, data))),
                                    (onClickDelete) => _presenter!.deleteClass(data['idClass']),
                                    (click) => null);
                          }).toList(),
                        );
                      }
                    },
                  )
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassAddPage(_course,'',null))),
        child: Icon(Icons.add, color: CommonColor.white,),
      ),
    );
  }
}
