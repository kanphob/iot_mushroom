//17/05/2565 ByBird
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_product.dart';
import 'package:siwat_mushroom/Utils/std_widget.dart';
import 'package:siwat_mushroom/provider/product/product_head_provider.dart';

class DailyProdListProvider extends ProductHeadProvider {
  final BuildContext context;

  DailyProdListProvider({
    required this.context,
  }) {
    initProvider();
  }

  bool bFirst = true;

  STDWidget widget = STDWidget();

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
    await getAllData(sUIDUser: 'cccc');
  }
}
