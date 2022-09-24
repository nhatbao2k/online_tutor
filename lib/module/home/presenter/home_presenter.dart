import 'package:online_tutor/res/images/image_view.dart';

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
}