import 'package:flutter/material.dart';
import 'package:siwat_mushroom/API/api_call.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Utils/std_widget.dart';

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
              print('${txtID.text} : ${txtPW.text}');
              String sResult = await APICall.httpGetForSignIn(
                  sUsername: txtID.text, sPassword: txtPW.text);
              if (sResult == 'Success') {
                removeSnackBar(context);
                bHaveToken = true;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ได้ รับ Token สำเร็จ'),
                  ),
                );
              } else {
                removeSnackBar(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ID ผู้ใช้งาน หรือ รหัสผ่านไม่ถูกต้อง'),
                  ),
                );
              }
            },
          );
        },
      );
    }
    return bHaveToken;
  }

  static void removeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
