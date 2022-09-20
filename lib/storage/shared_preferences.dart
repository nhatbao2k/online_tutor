
import 'package:online_tutor/common/common_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesData{
  static SharedPreferences? _preferences;

  static Future<void> SaveData(String key, var value) async{
    _preferences = await SharedPreferences.getInstance();
    if(value is String){
      await _preferences!.setString(key, value);
    }else if(value is int){
      await _preferences!.setInt(key, value);
    }else if(value is double){
      await _preferences!.setDouble(key, value);
    }else if(value is bool){
      await _preferences!.setBool(key, value);
    }else{
      await _preferences!.setStringList(key, value);
    }
  }

  static Future<dynamic> GetData(String key) async{
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.get(key)==null?'':_preferences!.get(key);
  }

  static Future<void> DeleteData(String key) async{
    _preferences = await SharedPreferences.getInstance();
    await _preferences!.remove(key);
  }
}