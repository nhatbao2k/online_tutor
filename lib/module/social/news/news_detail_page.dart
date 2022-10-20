import 'package:flutter/material.dart';
import 'package:online_tutor/common/custom_app_bar.dart';

import '../../../common/common_color.dart';
import '../../../common/common_function.dart';
import '../../../common/common_widget.dart';
import '../../../common/image_load.dart';
import '../../../common/view_image_list.dart';

class NewDetailPage extends StatelessWidget {
  Map<String, dynamic>? data;
  NewDetailPage(this.data);

  @override
  Widget build(BuildContext context) {
    List<dynamic> listImage = data!['mediaUrl'];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(appType: AppType.child, title: data!['description']),
          SizedBox(height: 8,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 4,),
                      ClipOval(
                        child: ImageLoad.imageNetwork(data!['userAvatar']!=null?data!['userAvatar']:'', 50, 50),
                      ),
                      SizedBox(width: 4,),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(data!['fullname']!=null?data!['fullname']:'', textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: CommonColor.black)),
                            CustomText(data!['timestamp']!=null?readTimestamp(data!['timestamp']):'', textStyle: TextStyle(fontSize: 12, color: CommonColor.black_light)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(data!['description']!=null?data!['description']:'', textStyle: TextStyle(color: CommonColor.black, fontSize: 14,)),
                  ),
                  Wrap(
                    children: List.generate(listImage.length, (index) => InkWell(
                        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewImageList(data!['mediaUrl'], index))),
                        child: Column(
                          children: [
                            ImageLoad.imageNetworkWrapContent(listImage[index] != null ? listImage[index] : ''),
                            Divider()
                          ],
                        ))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
