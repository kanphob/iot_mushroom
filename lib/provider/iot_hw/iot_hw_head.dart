import 'package:flutter/material.dart';
import 'package:siwat_mushroom/API/api_call.dart';
import 'package:siwat_mushroom/API/functions.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Utils/std_widget.dart';

class IOTHwHeader with ChangeNotifier {
  final BuildContext context;

  IOTHwHeader({
    required this.context,
  }) {
    initProv();
  }

  STDWidget widget = STDWidget();

  bool bFirst = true;

  initProv() async {
    await Future.delayed(const Duration(microseconds: 200));
    // Globals.sTokenIOT = '';
    bool bResult = await Functions.checkToken(context: context);
    if (bResult) {
      String sDevKeyTest = 'temp_1';
      String sOnOffDevKeyTest = 'IO1';
      await APICall.httpGetForDeviceValue(sDevKey: sDevKeyTest);
      bFirst = false;
      notifyListeners();
    }
  }
}
