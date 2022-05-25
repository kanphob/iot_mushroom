//17/05/2565 ByBird

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/API/api_call.dart';
import 'package:siwat_mushroom/API/functions.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_product.dart';
import 'package:siwat_mushroom/provider/product/product_head_provider.dart';
import 'package:uuid/uuid.dart';

class DailyProdFormProvider extends ProductHeadProvider {
  final BuildContext context;
  final String sUserID;
  final ModelProduct? model;

  DailyProdFormProvider({
    required this.context,
    required this.sUserID,
    this.model,
  }) {
    initProvider();
  }

  bool bFirst = true;
  late DateTime dtNow;
  int iRound = 0;
  String sUIDDoc = '';
  bool bLoadData = false;

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
      await setDefault();
      await setData();
      bFirst = false;
      notifyListeners();
    }
  }

  Future<void> setDefault() async {
    scrollBody = ScrollController(initialScrollOffset: 0);
    dtNow = DateTime.now();
    txtDateSave.text = Globals.dateFormatSave.format(dtNow);
    iRound = await getRound(sUIDUser: sUserID);
    var uuid = const Uuid();
    sUIDDoc = uuid.v4();
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
    Globals.sTokenIOT = '';
    bool bHave = await Functions.checkToken(context: context);
    print('Have Token : $bHave');
    if (bHave) {
      print('Token : ${Globals.sTokenIOT}');
      await APICall.httpGetForData();
    }
  }

  void onSave() async {
    Map<String, dynamic> data = await genDataFormInput();
    if (data.isNotEmpty) {
      int iSuccess = await saveData(sUIDDoc: sUIDDoc, data: data);
      if (iSuccess == 1) Navigator.pop(context, true);
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
