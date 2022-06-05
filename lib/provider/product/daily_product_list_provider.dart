//17/05/2565 ByBird
import 'package:flutter/material.dart';
import 'package:iot_mushroom/Constant/globals.dart';
import 'package:iot_mushroom/Model/model_product.dart';
import 'package:iot_mushroom/Screen/product/daily_product_form_screen.dart';
import 'package:iot_mushroom/provider/product/product_head_provider.dart';

class DailyProdListProvider extends ProductHeadProvider {
  final BuildContext context;
  final String sUserID;

  DailyProdListProvider({
    required this.context,
    required this.sUserID,
  }) {
    initProvider();
  }

  bool bFirst = true;

  // ListItem
  bool bLoadList = true;
  late ScrollController scrList;
  List<ModelProduct> listItem = [];
  List<ModelProduct> lmFilter = [];
  List<ModelProduct> lmShow = [];

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

  Future<void> setDefault() async {
    DateTime dateTime = DateTime.now();
    txtDateStart.text = Globals.dateFormatSave.format(dateTime);
    txtDateEnd.text = Globals.dateFormatSave.format(dateTime);
  }

  Future<void> loadDataFormServer() async {
    if (listItem.isEmpty) {
      listItem = await getAllData(sUIDUser: sUserID);
      await filterData();
    }
  }

  Future<void> filterData() async {
    if (listItem.isNotEmpty) {
      lmShow.clear();
      for (var m in listItem) {
        if (txtSearch.text.isNotEmpty) {
          if (m.sDateSave
              .toLowerCase()
              .contains(txtSearch.text.toLowerCase())) {
            lmFilter.add(m);
          }
        } else {
          lmFilter.add(m);
        }
      }
    }
    lmShow = lmFilter;
  }

  onChangeSearch() async {
    await filterData();
    notifyListeners();
  }

  onTapAdd() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyProdFormScreen(
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
    required ModelProduct md,
  }) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyProdFormScreen(
          sUserID: sUserID,
          model: md,
          sMode: Globals.sModeVIEW,
        ),
      ),
    );
  }

  onTapEdit({
    required ModelProduct md,
  }) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyProdFormScreen(
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

  void removeSnackBar() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
