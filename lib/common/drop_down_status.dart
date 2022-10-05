import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../module/class/model/status.dart';
import 'common_color.dart';
import 'common_widget.dart';

class DropDownBoxStatus extends StatelessWidget {
  final value;
  final List<Status> itemsList;
  final Function(dynamic value) onChanged;

  const DropDownBoxStatus({
    required this.value,
    required this.itemsList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
                color: CommonColor.blue
            )
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton2(
                  isExpanded: true,
                  value: value,
                  iconEnabledColor: CommonColor.greyLight,
                  iconDisabledColor: CommonColor.greyLight,
                  items: itemsList
                      .map((Status item) => DropdownMenuItem<Status>(
                    value: item,
                    child: CustomText(
                      item.getTitle,
                      textStyle: TextStyle(fontSize: 16, color: CommonColor.black),
                    ),
                  ))
                      .toList(),
                  onChanged: (value) => onChanged(value),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dropdownMaxHeight: MediaQuery.of(context).size.height/2,
                  dropdownWidth: MediaQuery.of(context).size.width/2+25,
                ),
              )
          ),
        ),
      ),
    );
  }
}