import 'package:flutter/material.dart';
import 'package:iot_mushroom/API/functions.dart';
import 'package:iot_mushroom/Constant/field_master.dart';

class ModelItem {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtQty = TextEditingController(text: '0.00');
  FocusNode fnQty = FocusNode();
  double dQty = 0.00;
  TextEditingController txtPrice = TextEditingController(text: '0.00');
  FocusNode fnPrice = FocusNode();
  double dPrice = 0.00;
  TextEditingController txtPriceAmt = TextEditingController(text: '0.00');

  formJson(Map<String, dynamic> map) {
    txtName.text = map[FieldMaster.sItemName];
    txtQty.text = map[FieldMaster.sItemQTY];
    dQty = Functions.numberFromString(txtQty.text);
    txtPrice.text = map[FieldMaster.sItemPrice];
    dPrice = Functions.numberFromString(txtPrice.text);
    txtPriceAmt.text = map[FieldMaster.sItemAMT];
  }
}
