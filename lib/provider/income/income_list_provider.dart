import 'package:flutter/material.dart';
import 'package:iot_mushroom/Constant/globals.dart';
import 'package:iot_mushroom/Model/model_income.dart';
import 'package:iot_mushroom/Screen/income/income_form_screen.dart';
import 'package:iot_mushroom/Utils/std_widget.dart';
import 'package:iot_mushroom/provider/income/income_head_provider.dart';

class IncomeListProvider extends IncomeHeadProvider{
  BuildContext context;

  String sUserID;
  bool bFirst = true, bLoadList = true;

  List<ModelIncome> listItem = [];

  late ScrollController scrList;

  STDWidget widget = STDWidget();


  IncomeListProvider({required this.context,required this.sUserID}){
    initProvider();
  }

  initProvider() async {
    if (bFirst) {
      scrList = ScrollController(initialScrollOffset: 0);
      // await setDefault();
      bFirst = false;
      await loadDataFormServer();
      bLoadList = false;
      notifyListeners();
    }
  }

  Future<void> loadDataFormServer() async {
    if (listItem.isEmpty) {
      listItem = await getAllData(sUIDUser: sUserID);
    }
  }

  onTapAdd() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomeFormScreen(
          sUserID: sUserID,
          sMode: Globals.sModeADD,
        ),
      ),
    );
    if (result != null) {
      listItem.clear();
      await loadDataFormServer();
      notifyListeners();
    }
  }

  onTapView({
    required ModelIncome md,
  }) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomeFormScreen(
          sUserID: sUserID,
          model: md,
          sMode: Globals.sModeVIEW,
        ),
      ),
    );
    if (result != null) {
      listItem.clear();
      await loadDataFormServer();
      notifyListeners();
    }
  }

  onTapEdit({
    required ModelIncome md,
  }) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomeFormScreen(
          sUserID: sUserID,
          model: md,
          sMode: Globals.sModeEDIT,
        ),
      ),
    );
    if (result != null) {
      listItem.clear();
      await loadDataFormServer();
      notifyListeners();
    }
  }
}