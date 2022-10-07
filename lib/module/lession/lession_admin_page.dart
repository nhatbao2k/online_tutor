import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';
import 'package:online_tutor/module/class/model/Lession.dart';
import 'package:online_tutor/module/lession/lession_product_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessionAdminPage extends StatefulWidget {
  Lession? _lession;
  String? _type;

  LessionAdminPage(this._lession, this._type);

  @override
  State<LessionAdminPage> createState() => _LessionAdminPageState(_lession, _type);
}

class _LessionAdminPageState extends State<LessionAdminPage> {
  Lession? _lession;
  String? _type;
  _LessionAdminPageState(this._lession, this._type);

  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  bool _isPlayerReady = false;


  @override
  void initState() {
    FirebaseFirestore.instance.collection('lessiom_detail').doc(_lession!.lessionId).get().then((value) {

    });
    _loadInitYoutube();
  }

  void _loadInitYoutube(){
    _controller = YoutubePlayerController(
      initialVideoId: 'W-MihXf7Y2c',
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
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: (){
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
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
                  children: [
                    Container(
                      child: Text('1'),
                    ),
                    Container(
                      child: Text('1'),
                    ),
                    Container(
                      child: Text('1'),
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
                      builder: (_) => LessionProductPage(_lession, ''))),
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
}
