import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/lession/model/discuss.dart';
import 'package:online_tutor/module/lession/model/lession_detail.dart';

import '../../../common/image_load.dart';

class DiscussPage extends StatefulWidget {

  LessionDetail? _lession;

  DiscussPage(this._lession);

  @override
  State<DiscussPage> createState() => _DiscussPageState(_lession);
}

class _DiscussPageState extends State<DiscussPage> {
  LessionDetail? _lession;

  _DiscussPageState(this._lession);

  Stream<DocumentSnapshot>? _stream;
  @override
  void initState() {
    _stream = FirebaseFirestore.instance.collection('lession_detail').doc(_lession!.idLessionDetail!)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _stream!,
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return LoadingView();
          }else if(snapshot.hasError){
            return NoDataView(Languages.of(context).noData);
          }else if(!snapshot.hasData){
            return NoDataView(Languages.of(context).noData);
          }else{
            dynamic data = snapshot.data!.data();
            LessionDetail detail = LessionDetail.fromJson(data);
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(8),
                    itemCount: detail.discuss!.length,
                    itemBuilder: (context, index)=>_itemChat(detail.discuss![index]),
                  ),
                ),
                Container(
                  color: CommonColor.white,
                  height: 60,
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _itemChat(Discuss discuss){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: ImageLoad.imageNetwork(discuss.imageLink, 30, 30),
        ),
        SizedBox(width: 8,),
        SizedBox(
          width: getWidthDevice(context)/1.5,
          child: CustomText(discuss.content!, textStyle: TextStyle(fontSize: 14, color: CommonColor.black)),
        ),
      ],
    );
  }
}
