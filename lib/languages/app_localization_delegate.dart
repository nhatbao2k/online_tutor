import 'package:flutter/material.dart';

import 'languages.dart';
import 'languages_en.dart';
import 'languages_vn.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages>{
  @override
  bool isSupported(Locale locale) => ['en', 'vn'].contains(locale.languageCode);

  @override
  Future<Languages> load(Locale locale) {
    // TODO: implement load
    return _load(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<Languages> old) {
    // TODO: implement shouldReload
    return false;
  }

  static Future<Languages> _load(Locale locale) async{
    switch(locale.languageCode){
      case 'en':
        return LanguageEn();
      case 'vn':
        return LanguagesVn();
      default:
        return LanguagesVn();
    }
  }
}