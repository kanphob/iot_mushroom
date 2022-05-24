//24/05/2565 ByBird

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siwat_mushroom/Constant/field_master.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';
import 'package:siwat_mushroom/Utils/std_widget.dart';

class CostMaterialHeadProvider with ChangeNotifier {
  final costRef = FirebaseFirestore.instance.collection('material');

  TextEditingController txtSearch = TextEditingController();

  STDWidget widget = STDWidget();

  Future<List<ModelCostMaterial>> getAllData({
    required String sUIDUser,
  }) async {
    List<ModelCostMaterial> list = [];
    await costRef
        .where(FieldMaster.sMaterialUserUID, isEqualTo: sUIDUser)
        .orderBy(
          FieldMaster.sMaterialDateSave,
        )
        .orderBy(
          FieldMaster.sMaterialSaveTime,
        )
        .get()
        .then((value) {
      for (var m in value.docChanges) {
        ModelCostMaterial md = ModelCostMaterial();
        md.formFireStore(json: m.doc.data()!);
        list.add(md);
      }
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }).timeout(
      const Duration(minutes: 1),
    );
    return list;
  }
}
