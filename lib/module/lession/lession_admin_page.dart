
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/common/single_state.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/lession/lession_product_page.dart';
import 'package:online_tutor/module/lession/presenter/lession_admin_presenter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../class/model/class_course.dart';
import '../class/model/lession.dart';
import '../class/model/my_class.dart';
import '../class/model/my_class_detail.dart';
import '../pdf_view/pdf_viewer_page.dart';

class LessionAdminPage extends StatefulWidget {
  Lession? _lession;
  String? _type;
  MyClassDetail? _myClassDetail;
  ClassCourse? _course;
  MyClass? _myClass;
  LessionAdminPage(this._lession, this._type, this._myClassDetail, this._myClass, this._course);

  @override
  State<LessionAdminPage> createState() => _LessionAdminPageState(_lession, _type, _myClassDetail, _myClass, _course);
}

class _LessionAdminPageState extends State<LessionAdminPage> {
  Lession? _lession;
  String? _type;
  MyClassDetail? _myClassDetail;
  ClassCourse? _course;
  MyClass? _myClass;
  _LessionAdminPageState(this._lession, this._type, this._myClassDetail, this._myClass, this._course);

  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  bool _isPlayerReady = false;
  LessionAdminPresenter? _presenter;
  bool _isLoadFirst = true;

  @override
  void initState() {
    _presenter = LessionAdminPresenter();
    _presenter!.getLessionDetail(_lession!);


  }

  void _loadInitYoutube(){
    _controller = YoutubePlayerController(
      initialVideoId: '${getYoutubeId(_presenter!.detail!.videoLink!)}',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        forceHD: false,
        enableCaption: true
      )
    )..addListener(() {_listen(); });
  }

  void _listen(){
    if(_isPlayerReady && mounted && !_controller.value.isFullScreen){
      setState((){
        _playerState = _controller.value.playerState;
      });
    }
  }


  @override
  void deactivate() {
    _controller.pause();
  }


  @override
  void dispose() {

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: CommonColor.white,
      child: Observer(
        builder: (_){
          if(_presenter!.state==SingleState.LOADING){
            return LoadingView();

          }else if(_presenter!.state==SingleState.NO_DATA){
            return NoDataView(Languages.of(context).noData);
          }else{
            if(_isLoadFirst){
              _loadInitYoutube();
              _isLoadFirst=false;
            }
            return YoutubePlayerBuilder(
              onExitFullScreen: (){
              },
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                onReady: (){
                  _isPlayerReady = true;
                },
                onEnded: (value){

                },
              ),
              builder: (context, player)=>DefaultTabController(
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 0,
                    elevation: 0,
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAppBar(appType: AppType.child, title: _lession!.nameLession!),
                      player,
                      Container(
                        width: getWidthDevice(context),
                        child: TabBar(
                          labelColor: CommonColor.blue,
                          tabs: [
                            Tab(
                              text: Languages.of(context).content,
                            ),
                            Tab(
                              text: Languages.of(context).exercise,
                            ),
                            Tab(
                              text: Languages.of(context).answer,
                            ),
                            Tab(
                              text: Languages.of(context).discuss,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                                child: _presenter!.detail!=null?PdfViewerPage(_presenter!.detail!.fileContent)
                                    :NoDataView(Languages.of(context).noData)
                            ),
                            Container(
                                child: _presenter!.detail!=null?PdfViewerPage(_presenter!.detail!.homework![0].question)
                                    :NoDataView(Languages.of(context).noData)
                            ),
                            Container(
                                child: _presenter!.detail!=null?PdfViewerPage(_presenter!.detail!.homework![0].answer)
                                    :NoDataView(Languages.of(context).noData)
                            ),
                            Container(
                              child: Text('1'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: ()=> {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LessionProductPage(_lession!, '', _course!, _myClass!, _myClassDetail!))),
                      _controller.pause(),
                    },
                    child: Icon(
                      Icons.add,
                      color: CommonColor.white,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
