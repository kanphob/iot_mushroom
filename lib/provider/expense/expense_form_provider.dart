
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_mushroom/API/functions.dart';
import 'package:iot_mushroom/Constant/drop_down_data.dart';
import 'package:iot_mushroom/Constant/globals.dart';
import 'package:iot_mushroom/Model/model_expense.dart';
import 'package:iot_mushroom/Model/model_item.dart';
import 'package:iot_mushroom/provider/expense/expense_head_provider.dart';
import 'package:uuid/uuid.dart';

class ExpenseFormProvider extends ExpenseHeadProvider {
  final BuildContext context;
  final String sUserID;
  final ModelExpense? model;
  final String? sMode;

  ExpenseFormProvider({
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

  String sMsgError = '';

  ModelExpense mdHead = ModelExpense();

  // FilterData
  List<DropDownData> listType = [];
  int iType = 0;
  List<DropDownData> listExpense = [];
  int iExpense = 0;

  // Items
  List<ModelItem> listItem = [];

  // Form
  TextEditingController txtDateSave = TextEditingController(),
      txtTemp = TextEditingController(text: '0');

  late ScrollController scrollBody;

  initProvider() async {
    if (bFirst) {
      await setDefault();
      // await setData();
      bFirst = false;
      notifyListeners();
    }
  }

  Future<void> setDefault() async {
    scrollBody = ScrollController(initialScrollOffset: 0);
    listType = DropDownData.getDataExpense();
    dtNow = DateTime.now();
    if (sMode == Globals.sModeADD) {
      txtDateSave.text = Globals.dateFormatSave.format(dtNow);
      await setDataDropDown();
      addNewItem();
    } else if (sMode == Globals.sModeVIEW || sMode == Globals.sModeEDIT) {
      mdHead = model!;
      txtDateSave.text = model!.sSaveDateTime;
      await setItem(mdHead.sItem);
      if (mdHead.sExpenseType == 'REX') {
        iType = 1;
      }
      listExpense = DropDownData.getDataExpense();
    }
  }

  addNewItem() {
    ModelItem md = ModelItem();
    Functions.createFocusNode(fn: md.fnQty, ctrl: md.txtQty);
    Functions.createFocusNode(fn: md.fnPrice, ctrl: md.txtPrice);
    listItem.add(md);
    sumItem();
  }

  Future<void> setItem(String sItem) async {
    dynamic dJson = jsonDecode(sItem);
    List<dynamic> lItem = dJson;
    if (kDebugMode) {
      print(dJson);
    }
    for (int i = 0; i < lItem.length; i++) {
      dynamic temp = lItem[i];
      Map<String, dynamic> map = HashMap.from(temp);
      ModelItem modelItem = ModelItem();
      modelItem.formJson(map);
      Functions.createFocusNode(fn: modelItem.fnQty, ctrl: modelItem.txtQty);
      Functions.createFocusNode(
          fn: modelItem.fnPrice, ctrl: modelItem.txtPrice);
      listItem.add(modelItem);
    }
    sumItem();
  }

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

  Future<void> setDataDropDown() async {
      listExpense = DropDownData.getDataExpense();
      mdHead.sExpenseType = listType[iType].sVal;
  }

  void onChangeType(int index) async {
    iType = index;
    await setDataDropDown();
    notifyListeners();
  }

  void onChangeExpense(int index) async {
    iExpense = index;
    mdHead.sExpenseType = listExpense[index].sVal;
  }

  void addItem() {
    addNewItem();
    notifyListeners();
  }

  void deleteItem() {
    if (listItem.length <= 1) {
      Functions.removeSnackBar(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('??????????????????????????????????????????????????? 1'),
        ),
      );
    } else {
      listItem.removeLast();
      sumItem();
      notifyListeners();
    }
  }

  void onChangeQTY(String sVal, ModelItem item) {
    item.dQty = Functions.numberFromString(sVal);
    sumItem();
    if (kDebugMode) {
      print('QTY : ${item.dQty}');
    }
  }

  void onChangePrice(String sVal, ModelItem item) {
    item.dPrice = Functions.numberFromString(sVal);
    sumItem();
    if (kDebugMode) {
      print('Price : ${item.dPrice}');
    }
  }

  void sumItem() {
    mdHead.dTotalAmt = 0.00;
    for (var item in listItem) {
      double dSum = item.dQty * item.dPrice;
      item.txtPriceAmt.text = Functions.numberDoublerSave(dSum);
      mdHead.dTotalAmt += dSum;
    }
    mdHead.sTotalAmt = Functions.numberDoublerSave(mdHead.dTotalAmt);
    notifyListeners();
  }

  void onTapSave() async {
    bool bVal = validate();
    if (bVal) {
      Functions.removeSnackBar(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(sMsgError),
        ),
      );
    } else {
      String sUIDDoc = '';
      if (sMode == Globals.sModeADD) {
        var uuid = const Uuid();
        sUIDDoc = uuid.v4();
      } else {
        sUIDDoc = mdHead.sUID;
      }
      mdHead.sUserUID = sUserID;
      mdHead.sUID = sUIDDoc;
      mdHead.sSaveDateTime = txtDateSave.text;
      mdHead.sSaveTimeStamp = dtNow.toIso8601String();
      mdHead.sItem = await Functions.genItemToJson(listItem);
      Map<String, dynamic> data = mdHead.toMap();
      if (data.isNotEmpty) {
        int iSuccess = await saveData(sUIDDoc: sUIDDoc, data: data);
        if (iSuccess == 1) Navigator.pop(context, true);
      }
    }
  }

  bool validate() {
    bool bVal = false;
    for (var item in listItem) {
      if (item.txtName.text.isEmpty) {
        sMsgError = '??????????????????????????????????????????';
        bVal = true;
        break;
      }
    }
    return bVal;
  }

  void pop() {
    Navigator.pop(context, false);
  }
}
