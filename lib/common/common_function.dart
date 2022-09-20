
import 'package:flutter/cupertino.dart';

double getWidthDevice(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getHeightDevice(BuildContext context){
  return MediaQuery.of(context).size.height;
}

bool checkLandscape(BuildContext context){
  return MediaQuery.of(context).orientation == Orientation.landscape;
}

bool validateEmail(String? value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty || !regex.hasMatch(value))
    return false;
  else
    return true;
}

void hideKeyboard(){
  FocusManager.instance.primaryFocus?.unfocus();
}