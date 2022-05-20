//17/05/2565 ByBird
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_product.dart';
import 'package:siwat_mushroom/Screen/product/daily_product_form_screen.dart';
import 'package:siwat_mushroom/provider/product/product_head_provider.dart';

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
  List<ModelProduct> listItem = [];

  initProvider() async {
    if (bFirst) {
      await setDefault();
      bFirst = false;
      await loadDataFormServer();
      bLoadList = false;
      notifyListeners();
    }
  }

  Future<void> setDefault() async {
    DateTime dateTime = DateTime.now();
    txtDateStart.text = Globals.dateFormatUser.format(dateTime);
    txtDateEnd.text = Globals.dateFormatUser.format(dateTime);
  }

  Future<void> loadDataFormServer() async {
    listItem = await getAllData(sUIDUser: 'cccc');
  }

  onTapAdd() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DailyProdFormScreen(
          sUserID: 'cccc',
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
