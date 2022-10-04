import 'package:flutter/material.dart';
import 'package:online_tutor/common/common_color.dart';

class CommonTheme{
  static InputDecoration textFieldInputDecoration({IconData? iconData, String? labelText, String? hintText, String? errorText}){
    InputDecoration decoration = InputDecoration(
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: CommonColor.blue),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CommonColor.blueLight),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        hintText: hintText,
        // helperText: errorText,
        errorText: errorText,
        labelText: labelText,
        prefixText: '',
        suffixText: '',
        suffixStyle: const TextStyle(color: CommonColor.red),
    );
    return decoration;
  }
}