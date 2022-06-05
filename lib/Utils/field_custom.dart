import 'package:flutter/material.dart';
import 'package:iot_mushroom/Utils/font_thai.dart';

class FieldCustom {
  static Widget item({
    TextEditingController? ctrl,
    FocusNode? fn,
    TextAlign textAlign = TextAlign.end,
    TextInputType inputType = TextInputType.text,
    Function(String)? onChange,
    bool read = false,
  }) {
    return TextField(
      controller: ctrl,
      focusNode: fn,
      style: FontThai.text16BlackNormal,
      textAlign: textAlign,
      keyboardType: inputType,
      readOnly: read,
      onChanged: onChange,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(5),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
