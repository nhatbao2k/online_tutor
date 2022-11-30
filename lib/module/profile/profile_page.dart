import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/image_load.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/account_detail/account_detail_page.dart';
import 'package:online_tutor/module/profile/presenter/profile_presenter.dart';
import 'package:online_tutor/module/teacher/teacher_page.dart';
import 'package:online_tutor/res/images/image_view.dart';

import '../../common/common_function.dart';
import '../document/document_page.dart';

class ProfilePage extends StatefulWidget{
  String? _role;

  ProfilePage(this._role);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfilePage();
  }
  
}

class _ProfilePage extends State<ProfilePage>{
  Map<String, dynamic>? _user;
  ProfilePresenter? _presenter;
  Stream<DocumentSnapshot>? _streamUser;
  @override
  void initState() {
    _presenter = ProfilePresenter();
    initData();
  }

  Future<void> initData() async{
    _user = await _presenter!.getAccountInfor();
    print(_user);
    if(_user!=null){
      _streamUser = FirebaseFirestore.instance.collection('users').doc(_user!['phone']).snapshots();
      setState(()=>null);
    }
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             _header(),
              const SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _itemOption('Giới thiệu', Icons.info, CommonKey.INFORMATION),
                    _itemOption('Điều khoản', Icons.security_rounded, CommonKey.RULES)
                  ],
                ),
              ),
              const SizedBox(height: 8.0,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _itemOption('Hỗ trợ', Icons.support, CommonKey.SUPPORT),
                    _itemOption('Đăng ký & tư vấn', Icons.contact_mail, CommonKey.REGISTER)
                  ],
                ),
              ),
              const SizedBox(height: 8.0,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _itemOption('Bảng vàng', Icons.star, CommonKey.SUPPORT),
                    _itemOption('Tài liệu', Icons.library_books, CommonKey.DOCUMENT)
                  ],
                ),
              ),
              const SizedBox(height: 8.0,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _itemOption('Đội ngũ giáo viên', Icons.supervised_user_circle, CommonKey.TEAM_TEACHER),
                    _itemOption('Đổi mật khẩu', Icons.vpn_key_rounded, CommonKey.CHANGE_PASS)
                  ],
                ),
              ),
              SizedBox(height: 16,),
              _itemOption2('Cài đặt', Icons.settings, CommonKey.SETTING),
              SizedBox(height: 16,),
              _itemOption2('Đăng xuất', Icons.logout, CommonKey.LOGOUT)
            ],
          ),
        ),
      ),
    );
  }


  Widget _header(){
    return  Container(
      width: getWidthDevice(context),
      height: checkLandscape(context)?getWidthDevice(context)/4.5:getHeightDevice(context)/4.5,
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: const Radius.circular(16)),
        image: DecorationImage(
          image: const AssetImage(ImageView.banner_profile2),
          fit: BoxFit.fill,
        ),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: _streamUser,
        builder: (context, snapshots){
          if(snapshots.connectionState==ConnectionState.waiting){
            return LoadingView();
          }else if(snapshots.hasError){
            return _itemUser(null);
          }else if(!snapshots.hasData){
            return _itemUser(null);
          }else{
            Map<String, dynamic> data = snapshots.data!.data() as Map<String, dynamic>;
            return _itemUser(data);
          }
        },
      ),
    );
  }

  Widget _itemOption(String title, IconData iconData, String keyFlow){
    return   InkWell(
      onTap: (){
        if(CommonKey.TEAM_TEACHER==keyFlow){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>TeacherPage(widget._role)));
        }else if(CommonKey.DOCUMENT==keyFlow){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>DocumentPage(_user!)));
        }
      },
      child: Container(
        width: getWidthDevice(context)/2-16,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: CommonColor.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(iconData, color: CommonColor.blue,),
            const SizedBox(height: 8,),
            CustomText('$title', textStyle: const TextStyle(color: CommonColor.black, fontWeight: FontWeight.w500, fontSize: 14))
          ],
        ),
      ),
    );
  }

  Widget _itemOption2(String title, IconData iconData, String keyFlow){
    return InkWell(
      onTap: (){
        if(CommonKey.LOGOUT==keyFlow){
          signOut(context);
        }
      },
      child: Container(
        width: getWidthDevice(context)-16,
        height: getHeightDevice(context)*0.07,
        margin: EdgeInsets.only(right: 8, left: 8),
        padding: EdgeInsets.only(left: 4,right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: CommonColor.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0,3)
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, color: CommonColor.blueLight,),
            SizedBox(width: 4,),
            CustomText('$title', textStyle: TextStyle(color: CommonColor.black, fontSize: 14, fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    );
  }

  Widget _itemUser(Map<String, dynamic>? data){
    return Column(
      children: [
        const SizedBox(height: 16,),
        Stack(
            children:[
              Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(200)),
                      border: Border.all(
                          color: CommonColor.orangeOriginLight,
                          width: 1.0
                      )
                  ),
                  child: InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>AccountDetailPage(_user))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(200)),
                      child: data!=null
                          ?ImageLoad.imageNetwork(data['avatar'], 100, 100)
                          :Image(
                        image: AssetImage(
                            ImageView.truong_man
                        ),
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(200)),
                        color: CommonColor.white,
                        border: Border.all(width: 1.0, color: CommonColor.orangeOriginLight)
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.image, size: 12, color: CommonColor.grey,),
                        onPressed: (){
                          cropImage(context, (p0) {
                            showLoaderDialog(context);
                            _presenter!.UpdateImage(p0!, _user!['phone']).then((value) {
                              Navigator.pop(context);
                              if(!value){
                                showToast(Languages.of(context).onFailure);
                              }
                            });
                          }, '');
                        },
                      ),
                    ),
                  ))
            ]
        ),
        const SizedBox(height: 8,),
        CustomText('${data!=null?data['fullname']:''}', textStyle: const TextStyle(fontSize: 14, color: CommonColor.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}