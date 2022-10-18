import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_tutor/module/class/model/class_course.dart';
import 'package:online_tutor/res/images/image_view.dart';

import '../../../common/common_key.dart';
import '../../../storage/shared_preferences.dart';
import '../model/banner_slider.dart';

class HomePresenter {
  void initData(){
    getBanner();
  }

  List<BannerSlider> getBanner(){
    List<BannerSlider> bannerList = [
      BannerSlider(title: 'Giải pháp toàn diện về giáo dục trực tuyến', content: 'Chúng tôi hướng đến việc là một người bạn đồng hành tin cậy đi cùng các em trong học tập, lắng nghe và hướng dẫn “những người bạn nhỏ” lựa chọn giải pháp và hướng đi phù hợp.',linkImage: ImageView.banner_intro),
      BannerSlider(title: 'Các cuộc thi', content: 'Thử sức với các cuộc thi trong nước và quốc tế',linkImage: ImageView.banner_contest),
      BannerSlider(title: 'Bảng vàng', content: 'Nơi vinh danh các gương mặt tiêu biểu trong quá trình học tập',linkImage: ImageView.banner_golden),
      BannerSlider(title: 'Thi thử', content: 'Kiểm tra năng lực của bạn bằng các đề thi được thiết kế theo chương trình sách giáo khoa',linkImage: ImageView.banner_test),
      BannerSlider(title: 'Tài liệu', content: 'Ngân hàng kiến thức với 7000+ bộ tài liệu',linkImage: ImageView.banner_document),
    ];
    return bannerList;
  }

  void RegisterClass(String idClass, List<dynamic> userRegister, String idCourse){
    FirebaseFirestore.instance.collection('class').doc(idClass).update({
      'subscribe': userRegister
    });
    FirebaseFirestore.instance.collection('course').doc(idCourse).update({
      'subscribe':userRegister
    });
  }

  Future<String> getUserInfo() async{
    String phone = '';
    dynamic data = await SharedPreferencesData.GetData(CommonKey.USER);
    if(data!=null){
      Map<String, dynamic>json = jsonDecode(data.toString());
      phone = json['phone']!=null?json['phone']:'';
    }
    return phone;
  }

  Future<ClassCourse> getCourse(String idCourse) async{
    ClassCourse course=ClassCourse('', '', '', '');
    await FirebaseFirestore.instance.collection('course').where('idCourse', isEqualTo: idCourse).get().then((value) {
      value.docs.forEach((element) {
        course = ClassCourse(element['idCourse'], element['idTeacher'], element['teacherName'], element['name']);
      });
    });
    print(course);
    return course;
  }
}