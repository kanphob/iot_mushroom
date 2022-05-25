//24/05/2565 ByBird

import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';
import 'package:siwat_mushroom/Screen/cost_material/cost_material_form_screen.dart';
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
  List<ModelCostMat> listItem = [];
  List<ModelCostMat> listTemp = [];
  List<ModelCostMat> lmFilter = [];
  List<ModelCostMat> lmShow = [];

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
      await filterData();
    }
  }

  Future<void> filterData() async {
    if (listItem.isNotEmpty) {
      lmShow.clear();
      for (var m in listItem) {
        if (txtSearch.text.isNotEmpty) {
          if (m.sSaveDateTime
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
        builder: (context) => CostMatFormScreen(
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
    required ModelCostMat md,
  }) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CostMatFormScreen(
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
}
