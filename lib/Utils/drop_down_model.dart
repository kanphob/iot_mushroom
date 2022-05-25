import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Constant/drop_down_data.dart';
import 'package:siwat_mushroom/Utils/font_thai.dart';

class DropDownModel {
  static EdgeInsets contentPadding =
      const EdgeInsets.symmetric(vertical: 10, horizontal: 10);

  static Widget dropDown({
    required List<DropDownData> items,
    required int valDrop,
    Function(int?)? onChange,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        enabled: enabled,
        contentPadding: contentPadding,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.blue,
        )),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue.shade900,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        isDense: true,
      ),
      items: items.map((value) {
        return DropdownMenuItem<int>(
          value: value.index.toInt(),
          child: Text(
            value.sLabel,
            style: FontThai.text16BlackNormal,
          ),
        );
      }).toList(),
      value: valDrop,
      onChanged: onChange,
    );
  }
}
