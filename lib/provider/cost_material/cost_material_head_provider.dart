//24/05/2565 ByBird

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iot_mushroom/Constant/drop_down_data.dart';
import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Model/model_cost_material.dart';
import 'package:iot_mushroom/Utils/std_widget.dart';

class CostMaterialHeadProvider with ChangeNotifier {
  final costRef = FirebaseFirestore.instance.collection('material');

  TextEditingController txtSearch = TextEditingController();

  STDWidget widget = STDWidget();

  Future<List<ModelCostMat>> getAllData({
    required String sUIDUser,
  }) async {
    List<ModelCostMat> list = [];
    await costRef
        .where(FieldMaster.sUserUID, isEqualTo: sUIDUser)
        .orderBy(
          FieldMaster.sDateSave,
        )
        .orderBy(
          FieldMaster.sSaveTimeStamp,
        )
        .get()
        .then((value) {
      for (var m in value.docChanges) {
        ModelCostMat md = ModelCostMat();
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

  Future<int> saveData({
    required String sUIDDoc,
    required Map<String, dynamic> data,
  }) async {
    int iSuccess = 0;
    await costRef.doc(sUIDDoc).set(data).then((value) {
      iSuccess = 1;
    });
    return iSuccess;
  }

  Future<int> updateData({
    required String sUIDDoc,
    required Map<String, dynamic> data,
  }) async {
    int iSuccess = 0;
    await costRef.doc(sUIDDoc).update(data).then((value) {
      iSuccess = 1;
    });
    return iSuccess;
  }

  Map<String, String> valFormType(ModelCostMat md) {
    Map<String, String> data = {};
    List<DropDownData> listType = DropDownData.getDataTypeCost();
    List<DropDownData> listCost = [];
    int iType = 0;
    if (md.sTypeCost == 'LC') iType = 1;
    data[FieldMaster.sMatTypeCost] = listType[iType].sLabel;
    if (iType == 0) {
      int iCost = 0;
      if (md.sCost == 'IMC') iCost = 1;
      listCost = DropDownData.getDataMatCost();
      data[FieldMaster.sMatCost] = listCost[iCost].sLabel;
    } else {
      int iCost = 0;
      if (md.sCost == 'ILC') {
        iCost = 1;
      } else if (md.sCost == 'OC') {
        iCost = 2;
      }
      listCost = DropDownData.getDataLaborCost();
      data[FieldMaster.sMatCost] = listCost[iCost].sLabel;
    }
    return data;
  }
}
