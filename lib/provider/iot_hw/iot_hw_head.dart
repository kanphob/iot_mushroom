import 'package:flutter/material.dart';
import 'package:iot_mushroom/API/api_call.dart';
import 'package:iot_mushroom/API/functions.dart';
import 'package:iot_mushroom/Constant/globals.dart';
import 'package:iot_mushroom/Utils/std_widget.dart';

class IOTHwHeader with ChangeNotifier {
  final BuildContext context;

  IOTHwHeader({
    required this.context,
  }) {
    initProv();
  }

  STDWidget widget = STDWidget();

  bool bFirst = true;

  // dev key
  bool bIO = false;
  bool bOnOffIO = true;

  initProv() async {
    await Future.delayed(const Duration(microseconds: 200));
    // Globals.sTokenIOT = '';
    bool bResult = await Functions.checkToken(context: context);
    if (bResult) {
      // await APICall.getDeviceValue();

      bFirst = false;
      notifyListeners();
    }
  }

  void onChangedIO(val) {
    bIO = val;
    print('Dev_Key $bIO');
    notifyListeners();
  }

  void onChangedOnOff(val) {
    bOnOffIO = val;
    print('On_OFF $bOnOffIO');
    notifyListeners();
  }

  void onPushDataIO() async {
    String sDevKey = '';
    String sStatus = '';
    if (bIO) {
      sDevKey = 'IO2';
    } else {
      sDevKey = 'IO1';
    }
    if (bOnOffIO) {
      sStatus = 'true';
    } else {
      sStatus = 'false';
    }
    print('DevKey : $sDevKey');
    print('Status : $sStatus');
    var mResult = await APICall.deviceIO(
      sDevKey: sDevKey,
      sStatus: sStatus,
    );
    print(mResult);
  }
}
