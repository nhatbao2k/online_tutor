import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';
import 'package:online_tutor/common/common_function.dart';
import 'package:online_tutor/common/common_key.dart';
import 'package:online_tutor/common/common_widget.dart';
import 'package:online_tutor/common/custom_app_bar.dart';
import 'package:online_tutor/languages/languages.dart';

class AdvisePage extends StatefulWidget{
  String? _keyFlow;

  AdvisePage(this._keyFlow);

  @override
  State<StatefulWidget> createState() => _AdvisePage(_keyFlow);
}

class _AdvisePage extends State<AdvisePage>{
  String? _keyFlow;

  _AdvisePage(this._keyFlow);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: ()=>hideKeyboard(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonKey.HOME_PAGE==_keyFlow?SizedBox():CustomAppBar(appType: AppType.child, title: Languages.of(context).registerAdvise),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Languages.of(context).fullName,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ), SizedBox(height: 8,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Languages.of(context).phone,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Languages.of(context).email,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Languages.of(context).enterContent,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 8,),
                  ElevatedButton(
                    onPressed: ()=>null,
                    child: CustomText(Languages.of(context).submitInfo, textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CommonColor.white)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}