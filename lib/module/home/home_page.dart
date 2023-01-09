import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/advise/advise_page.dart';
import 'package:online_tutor/module/class/model/my_class.dart';
import 'package:online_tutor/module/home/presenter/home_presenter.dart';


import '../class/class_detail_admin_page.dart';
import '../class/class_page.dart';
import '../class/model/class_course.dart';
import '../course/course_page.dart';
import 'model/banner_slider.dart';

class HomePage extends StatefulWidget{
  String? _role;

  HomePage(this._role);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage(_role);
  }
}

class _HomePage extends State<HomePage>{

  List<BannerSlider> _bannerList = [];
  HomePresenter? _presenter;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  Stream<QuerySnapshot>? _streamCourse;
  Stream<QuerySnapshot>? _streamClass;
  Stream<QuerySnapshot>? _streamRatings;
  String? _role;
  String? _phone = '';

  _HomePage(this._role);

  @override
  void initState() {
    _presenter = HomePresenter();
    _getAccountInfor();
    _bannerList = _presenter!.getBanner();
    _streamCourse = FirebaseFirestore.instance.collection('course').snapshots();
    _streamClass = FirebaseFirestore.instance.collection('class').snapshots();
    _streamRatings = FirebaseFirestore.instance.collection('ratings').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(appType: AppType.appbar_home, title: '',),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: false,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }), items: List.generate(_bannerList.length, (index) {
                            return _item(_bannerList[index]);
                    }),
                    ),
                    SizedBox(height: 4,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _bannerList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: EdgeInsets.symmetric( horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : CommonColor.blueDeep)
                                    .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16,),
                    itemSeeMore(context, Languages.of(context).course,(call) {
                      if(_role==null||_role!.isEmpty){
                        CustomDialog(context: context, content: Languages.of(context).requireLogin);
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>CoursePage(_role, CommonKey.HOME_PAGE, _phone)));
                      }
                    }),
                    SizedBox(height: 8,),
                    StreamBuilder<QuerySnapshot>(
                      stream: _streamCourse,
                      builder: (context, snapshot){
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return LoadingView();
                        }else if(snapshot.hasError){
                          return NoDataView(Languages.of(context).noData);
                        }else{
                          return Container(
                            height: 300,
                            child: ListView(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs.map((e) {
                                Map<String, dynamic> data = e.data() as  Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: itemClass(context, data['name'], data['teacherName'], data['imageLink'], (click) => {
                                    if(_role==null||_role!.isEmpty){
                                      CustomDialog(context: context, content: Languages.of(context).requireLogin)
                                    }else{
                                      if(CommonKey.ADMIN==_role||(CommonKey.TEACHER==_role&&_phone==data['idTeacher'])){
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassPage(ClassCourse(data['idCourse'], data['idTeacher'], data['teacherName'], data['name']), _role,''))),
                                      }else if(CommonKey.MEMBER==_role){
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassPage(ClassCourse(data['idCourse'], data['idTeacher'], data['teacherName'], data['name']), _role,CommonKey.MEMBER))),
                                      } else{
                                        showToast(Languages.of(context).denyAccess)
                                      }

                                    }

                                  }, false),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 16,),
                    itemSeeMore(context, Languages.of(context).classStudy, (call) {
                      if(_role==null||_role!.isEmpty){
                        CustomDialog(context: context, content: Languages.of(context).requireLogin);
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassPage(null, _role, '')));
                      }
                    }),
                    StreamBuilder<QuerySnapshot>(
                      stream: _streamClass,
                      builder: (context, snapshots){
                        if(snapshots.connectionState==ConnectionState.waiting){
                          return SizedBox();
                        }else if(snapshots.hasError){
                          return NoDataView(Languages.of(context).noData);
                        }else{
                          return Container(
                            height: 300,
                            child: ListView(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: snapshots.data!.docs.map((e) {
                                Map<String, dynamic> data = e.data() as  Map<String, dynamic>;
                                List<dynamic> listUser = data['subscribe'];
                                MyClass myClass = MyClass.fromJson(data);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: itemClass(context, data['nameClass'], data['teacherName'], data['imageLink'], (click) => {
                                    if(_role==null||_role!.isEmpty){
                                      CustomDialog(context: context, content: Languages.of(context).requireLogin)
                                    }else{
                                      if(CommonKey.INK_WELL!=click&&!listUser.contains(_phone)){
                                        listUser.add(_phone!),
                                        _phone!.isNotEmpty?_presenter!.RegisterClass(data['idClass'], listUser, data['idCourse']):null,
                                      }else if(CommonKey.INK_WELL==click&&listUser.contains(_phone)){
                                        _navigatorClass(data, myClass),
                                      }else if(CommonKey.INK_WELL==click&&CommonKey.TEACHER==_role&&_phone==data['idTeacher']){
                                       _navigatorClass(data, myClass),
                                      }else if(CommonKey.INK_WELL==click&&CommonKey.TEACHER==_role&&_phone!=data['idTeacher']){
                                        showToast(Languages.of(context).denyAccess),
                                      } else if(CommonKey.INK_WELL==click&&CommonKey.ADMIN==_role){
                                        _navigatorClass(data, myClass),
                                      } else{
                                        showToast(Languages.of(context).requireClass)
                                      }
                                    }
                                  }, (listUser.contains(_phone)&&CommonKey.MEMBER==_role)?false:(CommonKey.TEACHER==_role||CommonKey.ADMIN==_role)?false:true),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 16,),
                    itemSeeMore(context, Languages.of(context).comment, (call) => null),
                    StreamBuilder<QuerySnapshot>(
                      stream: _streamRatings,
                      builder: (context, snapshots){
                        if(snapshots.connectionState==ConnectionState.waiting){
                          return SizedBox();
                        }else if(snapshots.hasError){
                          return NoDataView(Languages.of(context).noData);
                        }else{
                          return   Container(
                            height: 150,
                            width: getWidthDevice(context),
                            child: ListView(
                                scrollDirection:Axis.horizontal,
                              children: snapshots.data!.docs.map((e) {
                                Map<String, dynamic> data = e.data() as Map<String, dynamic>;
                                return _itemComment(data);
                              }).toList(),
                            )
                          );
                        }
                      },
                    ),

                    SizedBox(height: 16,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomText(Languages.of(context).registerAdvise, textStyle: TextStyle(fontWeight: FontWeight.bold, color: CommonColor.blue, fontSize: 14)),
                    ),
                    SizedBox(height: 4,),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: CommonColor.white
                      ),
                      child: AdvisePage(CommonKey.HOME_PAGE),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(BannerSlider banner){
    return Card(
      elevation: 2,
        child: Container(
          child: Stack(
            children: [
              Image.asset('${banner.linkImage}', fit: BoxFit.fill,width: getWidthDevice(context),height: getHeightDevice(context),),
              Positioned(
                bottom: 0,
                child: Container(
                  width: getWidthDevice(context),
                  decoration: BoxDecoration(
                    color: CommonColor.blackLight
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                        child: CustomText(banner.title!, textStyle: TextStyle(fontWeight: FontWeight.bold, color: CommonColor.white, fontSize: 16, overflow: TextOverflow.ellipsis), maxline: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
                        child: CustomText(banner.content!, textStyle: TextStyle(color: CommonColor.white, fontSize: 12, overflow: TextOverflow.ellipsis), maxline: 1),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Widget _itemComment(Map<String, dynamic> data){
    return   Container(
      width: getWidthDevice(context)*0.8,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: ImageLoad.imageNetwork(data['avatar'], 50, 50),
              ),
              SizedBox(width: 8,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(data['fullname'], textStyle: TextStyle(color: CommonColor.black, fontWeight: FontWeight.bold, fontSize: 14, overflow: TextOverflow.ellipsis), maxline: 1),
                    CustomText(CommonKey.MEMBER==data['role']?Languages.of(context).member:Languages.of(context).teacher, textStyle: TextStyle(color: CommonColor.black, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 4,),
          CustomText(data['nameClass'], textStyle: TextStyle(color: CommonColor.black, fontSize: 14, overflow: TextOverflow.ellipsis), maxline: 1),
          SizedBox(height: 4,),
          CustomText(data['comment'], textStyle: TextStyle(fontSize: 12, color: CommonColor.black, overflow: TextOverflow.ellipsis), maxline: 3)
        ],
      ),
    );
  }

  Future<void> _getAccountInfor() async{
    _phone = await _presenter!.getUserInfo();
    setState(()=>null);
  }
  
  void _navigatorClass(Map<String, dynamic> data, MyClass myClass){
    _presenter!.getCourse(data['idCourse']).then((value) {
      if(value!=null&&value.getIdCourse!.isNotEmpty){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ClassDetailAdminPage(myClass, value, _role)));
      }
    });
  }
}