//17/05/2565 ByBird

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_mushroom/API/api_call.dart';
import 'package:iot_mushroom/API/functions.dart';
import 'package:iot_mushroom/Constant/globals.dart';
import 'package:iot_mushroom/Model/model_product.dart';
import 'package:iot_mushroom/provider/product/product_head_provider.dart';
import 'package:uuid/uuid.dart';

class DailyProdFormProvider extends ProductHeadProvider {
  final BuildContext context;
  final String sUserID;
  final ModelProduct? model;
  final String? sMode;

  DailyProdFormProvider({
    required this.context,
    required this.sUserID,
    this.model,
    this.sMode,
  }) {
    initProvider();
  }

  bool bFirst = true;
  late DateTime dtNow;
  int iRound = 0;
  String sUIDDoc = '';
  bool bLoadData = false;
  bool bSync = false;

  // Form
  TextEditingController txtDateSave = TextEditingController(),
      txtTemp = TextEditingController(text: '0'),
      txtMoi = TextEditingController(text: '0'),
      txtLight = TextEditingController(text: '0'),
      txtCO2 = TextEditingController(text: '0'),
      txtFlower = TextEditingController(text: '0'),
      txtQP = TextEditingController(text: '0');

  FocusNode fnTemp = FocusNode(),
      fnMoi = FocusNode(),
      fnLight = FocusNode(),
      fnCO2 = FocusNode(),
      fnFlower = FocusNode(),
      fnQP = FocusNode();

  late ScrollController scrollBody;

  initProvider() async {
    if (bFirst) {
      await Future.delayed(const Duration(microseconds: 200));
      bool bResult = await Functions.checkToken(context: context);
      if (bResult) {
        await setDefault();
        await setData();
        bFirst = false;
        notifyListeners();
      }
    }
  }

  Future<void> setDefault() async {
    scrollBody = ScrollController(initialScrollOffset: 0);
    dtNow = DateTime.now();
    if (sMode == Globals.sModeADD) {
      txtDateSave.text = Globals.dateFormatSave.format(dtNow);
      iRound = await getRound(sUIDUser: sUserID);
      var uuid = const Uuid();
      sUIDDoc = uuid.v4();
      await setDefaultIOT();
    } else {
      sUIDDoc = model!.sUID;
    }
    createFocusNode(fn: fnTemp, ctrl: txtTemp);
    createFocusNode(fn: fnMoi, ctrl: txtMoi);
    createFocusNode(fn: fnLight, ctrl: txtLight);
    createFocusNode(fn: fnCO2, ctrl: txtCO2);
    createFocusNode(fn: fnFlower, ctrl: txtFlower);
    createFocusNode(fn: fnQP, ctrl: txtQP);
  }

  Future<void> setData() async {
    if (model != null) {
      txtDateSave.text = model!.sDateSave;
      txtTemp.text = model!.sTemperature;
      txtMoi.text = model!.sMoisture;
      txtLight.text = model!.sLight;
      txtCO2.text = model!.sCO2;
      txtFlower.text = model!.iNumFlower.toString();
      txtQP.text = model!.iQuantityProduced.toString();
      bLoadData = true;
    }
  }

  Future<void> setDefaultIOT() async {
    Map<String, dynamic> map = {};
    map['temp'] = await APICall.getDeviceValue(sDevKey: 'temp_1');
    map['hum'] = await APICall.getDeviceValue(sDevKey: 'hum_1');
    map['co2'] = await APICall.getDeviceValue(sDevKey: 'co2_1');
    map['light'] = await APICall.getDeviceValue(sDevKey: 'light_1');
    print(map);
    if (map.isNotEmpty) {
      txtTemp.text = map['temp'] ?? '';
      txtMoi.text = map['hum'] ?? '';
      txtCO2.text = map['co2'] ?? '';
      txtLight.text = map['light'] ?? '';
    }
  }

  void createFocusNode({
    required FocusNode fn,
    required TextEditingController ctrl,
  }) {
    fn.addListener(() {
      if (fn.hasFocus) {
        ctrl.selection =
            TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
      } else {
        if (ctrl.text.isEmpty) {
          ctrl.text = '0';
        }
      }
    });
  }

  //
  void onTapPickDate() async {
    DateTime? result = await showDatePicker(
      context: context,
      initialDate: dtNow,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (result != null) {
      txtDateSave.text = Globals.dateFormatSave.format(result);
    }
  }

  void syncDataIOT() async {
    bSync = true;
    notifyListeners();
    await setDefaultIOT();
    bSync = false;
    notifyListeners();
  }

  void onSave() async {
    Map<String, dynamic> data = await genDataFormInput();
    if (data.isNotEmpty) {
      int iSuccess = 0;
      if (sMode == Globals.sModeADD) {
        iSuccess = await saveData(sUIDDoc: sUIDDoc, data: data);
      } else {
        iSuccess = await updateData(sUIDDoc: sUIDDoc, data: data);
      }
      if (iSuccess == 1) {
        await Future.delayed(const Duration(microseconds: 200), () {
          Navigator.pop(context, true);
        });
      }
    }
    if (kDebugMode) {
      print(jsonEncode(data));
    }
  }

  Future<Map<String, dynamic>> genDataFormInput() async {
    ModelProduct md = ModelProduct();
    md.sUserUID = sUserID;
    md.sUID = sUIDDoc;
    md.sTemperature = txtTemp.text.trim();
    md.sMoisture = txtMoi.text.trim();
    md.sLight = txtLight.text.trim();
    md.sCO2 = txtCO2.text.trim();
    md.iNumFlower = int.parse(txtFlower.text.trim());
    md.iQuantityProduced = int.parse(txtQP.text.trim());
    md.sDateSave = txtDateSave.text.trim();
    md.sSaveTimeStamp = dtNow.toIso8601String();
    return md.toMap();
  }

  void pop() {
    Navigator.pop(context, false);
  }
}
