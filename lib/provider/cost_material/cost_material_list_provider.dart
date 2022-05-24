//24/05/2565 ByBird

import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';
import 'package:siwat_mushroom/provider/cost_material/cost_material_head_provider.dart';

class CostMatListProvider extends CostMaterialHeadProvider {
  final BuildContext context;
  final String sUserID;

  CostMatListProvider({
    required this.context,
    required this.sUserID,
  }) {
    initProvider();
  }

  bool bFirst = true;

  // ListItem
  late ScrollController scrList;
  bool bLoadList = true;
  List<ModelCostMaterial> listItem = [];
  List<ModelCostMaterial> lmFilter = [];
  List<ModelCostMaterial> lmShow = [];

  initProvider() async {
    if (bFirst) {
      scrList = ScrollController(initialScrollOffset: 0);
      // await setDefault();
      bFirst = false;
      // await loadDataFormServer();
      bLoadList = false;
      notifyListeners();
    }
  }

  onTapAdd() async {
    // var result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DailyProdFormScreen(
    //       sUserID: sUserID,
    //     ),
    //   ),
    // );
    // if (result != null) {
    //   listItem.clear();
    //   await loadDataFormServer();
    //   notifyListeners();
    // }
  }
}
