
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/single_state.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/schedule/presenter/schedule_presenter.dart';
import 'package:online_tutor/storage/shared_preferences.dart';

import '../class/model/my_class.dart';

class SchedulePage extends StatefulWidget {

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String _dateNow='';
  List<MyClass> _myClass = [];
  SchedulePresenter? _presenter;
  @override
  void initState() {
    _presenter = SchedulePresenter();
    _getData();
    _dateNow = getDateNow();
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
          CustomAppBar(appType: AppType.appbar_home, title: Languages.of(context).schedule),
          Observer(
            builder: (_){
              if(_presenter!.state==SingleState.LOADING){
                return LoadingView();
              }else if(_presenter!.state==SingleState.NO_DATA){
                return NoDataView(Languages.of(context).noData);
              }else{
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: checkLandscape(context)?getWidthDevice(context)/8:getHeightDevice(context)/8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 2,),
                          _itemDate(CommonKey.Monday,getDateWeek(1)),
                          _itemDate(CommonKey.Tuesday,getDateWeek(2)),
                          _itemDate(CommonKey.Wednesday,getDateWeek(3)),
                          _itemDate(CommonKey.Thursday,getDateWeek(4)),
                          _itemDate(CommonKey.Friday,getDateWeek(5)),
                          _itemDate(CommonKey.Saturday,getDateWeek(6)),
                          _itemDate(CommonKey.Sunday,getDateWeek(7)),
                          SizedBox(width: 2,)
                        ],
                      ),
                    ),
                    Container(
                      color: CommonColor.gray,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: _itemWatcher(CommonKey.MON)),
                          Expanded(child: _itemWatcher(CommonKey.TUE)),
                          Expanded(child: _itemWatcher(CommonKey.WED)),
                          Expanded(child: _itemWatcher(CommonKey.THU)),
                          Expanded(child: _itemWatcher(CommonKey.FRI)),
                          Expanded(child: _itemWatcher(CommonKey.SAT)),
                          Expanded(child: _itemWatcher(CommonKey.SUN)),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          )

        ],
      ),
    );
  }


  Widget _itemDate(String day, String date){
    return InkWell(
      onTap: ()=>setState((){
        _dateNow = date;
      }),
      splashColor: CommonColor.transparent,
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
        margin: EdgeInsets.only(left: 2, right: 2),
        width: checkLandscape(context)?getHeightDevice(context)/8:getWidthDevice(context)/8,
        height: checkLandscape(context)?_dateNow==date?getWidthDevice(context)/4:getHeightDevice(context)/5:_dateNow==date?getWidthDevice(context)/4:getWidthDevice(context)/5.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(200)),
            color: _dateNow==date?CommonColor.blue:CommonColor.gray,
            boxShadow: [
              BoxShadow(
                color: _dateNow==date?CommonColor.white.withOpacity(0.5):CommonColor.white.withOpacity(0),
                spreadRadius: _dateNow==date?1:0,
                offset: _dateNow==date?Offset(0.5, 0.5):Offset(0, 0),
              )
            ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText('${CommonKey.Monday==day
                ?Languages.of(context).monday
                :CommonKey.Tuesday==day
                ?Languages.of(context).tuesday
                :CommonKey.Wednesday==day
                ?Languages.of(context).wednesday
                :CommonKey.Thursday==day
                ?Languages.of(context).thurday
                :CommonKey.Friday==day
                ?Languages.of(context).friday
                :CommonKey.Saturday==day
                ?Languages.of(context).saturday:
            CommonKey.Sunday==day
                ?Languages.of(context).sunday:''}', textStyle: TextStyle(fontSize: 14, color: _dateNow==date?CommonColor.white:CommonColor.black_light)),
            CustomText('$date', textStyle: TextStyle(fontSize: 12, color: _dateNow==date?CommonColor.white:CommonColor.black_light))
          ],
        ),
      ),
    );
  }

  Widget _itemSchedule(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 8,),
        Container(
            width: getWidthDevice(context)*0.2-8,
            child: CustomText('19:00', textStyle: TextStyle(color: CommonColor.black, fontSize: 16), textAlign: TextAlign.center)),
        Container(
          width: getWidthDevice(context)*0.8-8,
          height: checkLandscape(context)?getWidthDevice(context)/4.5:getHeightDevice(context)/5,
          decoration: BoxDecoration(
              color: CommonColor.white,

              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color:CommonColor.greyLight.withOpacity(0.2),
                  spreadRadius: 1,
                  offset: Offset(0, 0),
                )
              ]
          ),
          padding: EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText('name', textStyle: TextStyle(fontSize: 18, color: CommonColor.black, overflow: TextOverflow.ellipsis), maxline: 1),
              SizedBox(height: 4,),
              RichText(
                text: TextSpan(
                    text: 'lớp: ',
                    style: TextStyle(fontSize: 16, color: CommonColor.black),
                    children: [
                      WidgetSpan(
                          child: CustomText('ông bụt', maxline: 1, textStyle: TextStyle(fontSize: 16, color: CommonColor.black, overflow: TextOverflow.ellipsis))
                      )
                    ]
                ),
              ),
              SizedBox(height: 4,),
              RichText(
                text: TextSpan(
                    text: 'Giáo viên: ',
                    style: TextStyle(fontSize: 16, color: CommonColor.black),
                    children: [
                      WidgetSpan(
                          child: CustomText('heh', maxline: 1, textStyle: TextStyle(fontSize: 16, color: CommonColor.black,overflow: TextOverflow.ellipsis))
                      )
                    ]
                ),
              ),
              SizedBox(height: 8,),

            ],
          ),
        ),
        SizedBox(width: 8,)
      ],
    );
  }

  Widget _itemWatcher(String day){
    return  Container(
      padding: EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
      height: checkLandscape(context)?getWidthDevice(context)/8:getHeightDevice(context)/8,
      decoration: BoxDecoration(
          color: CommonColor.greyLight,
          border: Border(
              right: BorderSide(
                  width: 1,
                  color: CommonColor.gray
              )
          )
      ),
      child: ListView.separated(
        itemBuilder: (context, index)=>Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              color:CommonColor.white,
              borderRadius: BorderRadius.all(Radius.circular(25))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 2.0,right: 2,top: 4,bottom: 4),
            child: CustomText('${
                day==_presenter!.listMon[index].startDate?_presenter!.listMon[index].startHours
                    :day==_presenter!.listTue[index].startDate?_presenter!.listTue[index].startHours
                    :day==_presenter!.listWeb[index].startDate?_presenter!.listWeb[index].startHours
                    :day==_presenter!.listThu[index].startDate?_presenter!.listThu[index].startHours
                    :day==_presenter!.listFri[index].startDate?_presenter!.listFri[index].startHours
                    :day==_presenter!.listSat[index].startDate?_presenter!.listSat[index].startHours
                    :_presenter!.listSun[index].startHours
            }',
                textStyle: TextStyle(fontSize: 12, color: CommonColor.black),
          ),
        ),
      ), itemCount: CommonKey.MON==day?_presenter!.listMon.length
        :CommonKey.TUE==day?_presenter!.listTue.length
        :CommonKey.WED==day?_presenter!.listWeb.length
        :CommonKey.THU==day?_presenter!.listThu.length
        :CommonKey.FRI==day?_presenter!.listFri.length
        :CommonKey.SAT==day?_presenter!.listSat.length
        :_presenter!.listSun.length,  separatorBuilder: (context, index)=>SizedBox(height: 4,),
    ));
  }

  Future<void> _getData() async{
    dynamic data =await SharedPreferencesData.GetData(CommonKey.USER);
    if(data!=null){
      Map<String, dynamic>json = jsonDecode(data.toString());
      String phone = json['phone']!=null?json['phone']:'';
      _myClass = await
      _presenter!.getSchedule(phone);
    }

  }
}
