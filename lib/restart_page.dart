import 'package:flutter/material.dart';

class RestartPage extends StatefulWidget{
  final Widget child;
  RestartPage({required this.child});
  static void restartApp(BuildContext context){
    context.findAncestorStateOfType<_RestartPage>()!.restartApp();
  }
  @override
  State<StatefulWidget> createState() => _RestartPage();

}

class _RestartPage extends State<RestartPage>{
  Key key = UniqueKey();
  void restartApp(){
    setState((){
      key = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }

}