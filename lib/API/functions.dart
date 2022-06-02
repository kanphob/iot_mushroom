import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/API/api_call.dart';
import 'package:siwat_mushroom/Constant/field_master.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_item.dart';
import 'package:siwat_mushroom/Utils/std_widget.dart';
import 'package:intl/intl.dart';

class Functions {
  static Future<bool> checkToken({
    required BuildContext context,
  }) async {
    bool bHaveToken = false;
    if (Globals.sTokenIOT.isNotEmpty) {
      bHaveToken = true;
    } else {
      TextEditingController txtID = TextEditingController(
            text: 'Mushroom',
          ),
          txtPW = TextEditingController(text: '1234');
      await showDialog(
        context: context,
        builder: (_) {
          return STDWidget.loginIotDialog(
            txtID: txtID,
            txtPW: txtPW,
            onSubmitLogin: () async {
              // if (kDebugMode) {
              //   print('${txtID.text} : ${txtPW.text}');
              // }
              String sResult = await APICall.httpGetForSignIn(
                  sUsername: txtID.text, sPassword: txtPW.text);
              if (sResult == 'Success') {
                await Future.delayed(const Duration(microseconds: 200), () {
                  removeSnackBar(context);
                  bHaveToken = true;
                  navigatorPop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ได้ รับ Token สำเร็จ'),
                    ),
                  );
                });
              } else {
                await Future.delayed(Duration.zero, () {
                  removeSnackBar(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ID ผู้ใช้งาน หรือ รหัสผ่านไม่ถูกต้อง'),
                    ),
                  );
                });
              }
            },
          );
        },
      );
    }
    return bHaveToken;
  }

  static navigatorPop(BuildContext context) {
    Navigator.pop(context);
  }

  static void removeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  static double numberFromString(String number) {
    if (number == "") number = "0";
    number = number.replaceAll(",", "");
    return double.parse(number);
  }

  static String numberDoublerSave(double number) {
    final formatter = NumberFormat("##########0.00", "THB");
    String numberComma = formatter.format(number);
    return numberComma;
  }

  static void createFocusNode({
    required FocusNode fn,
    required TextEditingController ctrl,
    bool bMoney = true,
  }) {
    fn.addListener(() {
      if (fn.hasFocus) {
        ctrl.selection =
            TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
      } else {
        if (ctrl.text.isEmpty) {
          ctrl.text = '0';
        } else {
          if (bMoney) {
            double dText = numberFromString(ctrl.text);
            ctrl.text = numberDoublerSave(dText);
          }
        }
      }
    });
  }

  static Future<String> genItemToJson(List<ModelItem> list) async {
    List<Map<String, dynamic>> lItem = [];
    for (var item in list) {
      Map<String, dynamic> map = {};
      map[FieldMaster.sItemName] = item.txtName.text.trim();
      map[FieldMaster.sItemQTY] = item.txtQty.text.trim();
      map[FieldMaster.sItemPrice] = item.txtPrice.text.trim();
      map[FieldMaster.sItemAMT] = item.txtPriceAmt.text.trim();
      lItem.add(map);
    }
    String sItem = json.encode(lItem);
    return sItem;
  }
}
