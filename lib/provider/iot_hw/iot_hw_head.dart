import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_mushroom/API/api_call.dart';
import 'package:iot_mushroom/API/functions.dart';
import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Constant/globals.dart';
import 'package:iot_mushroom/Model/model_iot_item.dart';
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
  bool bLoadList = false;

  // dev key
  bool bIO = false;
  bool bOnOffIO = true;

  List<ModelIotItem> listItem = [];
  late ScrollController scrList;

  initProv() async {
    await Future.delayed(const Duration(microseconds: 200));
    // Globals.sTokenIOT = '';
    bool bResult = await Functions.checkToken(context: context);
    scrList = ScrollController(initialScrollOffset: 0);
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
    listItem.clear();
    await Future.delayed(const Duration(microseconds: 200), () {
      Functions.removeSnackBar(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mResult[FieldMaster.sApiValue]),
        ),
      );
    });
    if (bOnOffIO) {
      bLoadList = true;
      notifyListeners();
      await addDataIOT();
      bLoadList = false;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> addDataIOT() async {
    String sTemp = await APICall.getDeviceValue(sDevKey: 'temp_1');
    String sHum = await APICall.getDeviceValue(sDevKey: 'hum_1');
    String sCo = await APICall.getDeviceValue(sDevKey: 'co2_1');
    String sLig = await APICall.getDeviceValue(sDevKey: 'light_1');
    String sPress = await APICall.getDeviceValue(sDevKey: 'pres_3');
    if (sTemp.isNotEmpty) {
      ModelIotItem md = ModelIotItem();
      md.child = widget.imageIcon(
        'assets/images/temperature.png',
      );
      md.sValue = sTemp;
      listItem.add(md);
    } else {}
    if (sHum.isNotEmpty) {
      ModelIotItem md = ModelIotItem();
      md.child = widget.imageIcon(
        'assets/images/rainfall.png',
      );
      md.sValue = sHum;
      listItem.add(md);
    } else {}
    if (sCo.isNotEmpty) {
      ModelIotItem md = ModelIotItem();
      md.child = widget.imageIcon(
        'assets/images/co2.png',
      );
      md.sValue = sCo;
      listItem.add(md);
    } else {}
    if (sLig.isNotEmpty) {
      ModelIotItem md = ModelIotItem();
      md.child = widget.imageIcon(
        'assets/images/sunny.png',
      );
      md.sValue = sLig;
      listItem.add(md);
    } else {}
    if (sPress.isNotEmpty) {
      ModelIotItem md = ModelIotItem();
      md.child = widget.imageIcon(
        'assets/images/pressure.png',
      );
      md.sValue = sPress;
      listItem.add(md);
    } else {}
  }
}
