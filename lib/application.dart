import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:online_tutor/home.dart';
import 'package:online_tutor/res/languages/app_localization_delegate.dart';
import 'package:online_tutor/res/languages/locale_constant.dart';

class Application extends StatefulWidget{

  static void setLocale(BuildContext context, Locale newLocale){
    var state = context.findAncestorStateOfType<_Application>();
    state!.setLocale(newLocale);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Application();
  }

}

class _Application extends State<Application>{

  Locale? _locale;
  void setLocale(Locale locale){
    setState((){
      _locale = locale;
    });
  }


  @override
  void didChangeDependencies() async{
    getLocale().then((value){
      setState((){
        _locale = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      builder: (context, child){
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child!);
      },
      home: Home(),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en',''),
        Locale('vn','')
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }

}