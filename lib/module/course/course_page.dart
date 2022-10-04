import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/course/course_product_page.dart';
import 'package:online_tutor/module/course/presenter/course_prenter.dart';

class CoursePage extends StatefulWidget {
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Stream<QuerySnapshot>? _stream;
  CoursePresenter? _presenter;
  @override
  void initState() {
    _presenter = CoursePresenter();
    _stream = FirebaseFirestore.instance.collection('course').snapshots();
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
          CustomAppBar(appType: AppType.appbar_home, title: ''),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _stream,
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return LoadingView();
                      }else if(snapshot.hasError){
                        return NoDataView(Languages.of(context).noData);
                      }
                      return Wrap(
                        children: snapshot.data!.docs.map((e) {
                          Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
                          return itemCourse(context, data['name'], data['teacherName'], data['imageLink'],
                                  (onClickEdit) => Navigator.push(context, MaterialPageRoute(builder: (_)=>CourseProductPage(CommonKey.EDIT, data))),
                                  (onClickDelete) => _presenter!.deleteCourse(data['idCourse']),
                                  (click) => null);
                        }).toList(),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>CourseProductPage('',null))),
        child: Icon(Icons.add,),
      ),
    );
  }
}
