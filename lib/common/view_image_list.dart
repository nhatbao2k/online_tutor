import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:photo_view/photo_view.dart';

class ViewImageList extends StatefulWidget {
  List<dynamic>? _imageList;
  int? _postion;


  ViewImageList(this._imageList, this._postion);

  @override
  State<ViewImageList> createState() => _ViewImageListState();
}

class _ViewImageListState extends State<ViewImageList> {
  PageController? _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: widget._postion!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: CommonColor.black,
      ),
      body: Container(
        width: getWidthDevice(context),
        height: getHeightDevice(context),
        color: CommonColor.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: ()=>Navigator.pop(context),
              icon: Icon(
                Icons.close,
                color: CommonColor.grey,
              ),
            ),
            Expanded(child: Center(
              child: PageView.builder(
                  itemCount: widget._imageList!.length,
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    return _itemImage(widget._imageList![index]);
                  },
                  onPageChanged: (int index) {

                  }),
            ))
          ],),
      ),
    );
  }

  Widget _itemImage(String url){
    return Container(
      constraints: BoxConstraints(
        maxHeight: getHeightDevice(context),
        maxWidth: getWidthDevice(context),
      ),
      child: Center(
        child: PhotoView(
          imageProvider: NetworkImage(url),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}
