//17/05/2565 ByBird
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siwat_mushroom/Constant/field_master.dart';
import 'package:siwat_mushroom/Model/model_product.dart';
import 'package:siwat_mushroom/Utils/std_widget.dart';

class ProductHeadProvider with ChangeNotifier {
  final prodRef = FirebaseFirestore.instance.collection('product');

  // List
  TextEditingController txtDateStart = TextEditingController();
  TextEditingController txtDateEnd = TextEditingController();
  TextEditingController txtSearch = TextEditingController();

  STDWidget widget = STDWidget();

  Future<List<ModelProduct>> getAllData({
    required String sUIDUser,
  }) async {
    List<ModelProduct> list = [];
    await prodRef
        .where(FieldMaster.sProdUserUID, isEqualTo: sUIDUser)
        .orderBy(
          FieldMaster.sProdDateSave,
        )
        .orderBy(
          FieldMaster.sProdSaveTimeStamp,
        )
        .get()
        .then((value) {
      for (var m in value.docChanges) {
        ModelProduct md = ModelProduct();
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

  Future<int> getRound({
    required String sUIDUser,
  }) async {
    int iRound = 0;
    await prodRef
        .where(FieldMaster.sProdUserUID, isEqualTo: sUIDUser)
        .get()
        .then((value) {
      iRound = value.size + 1;
    });
    return iRound;
  }

  Future<int> saveData({
    required String sUIDDoc,
    required Map<String, dynamic> data,
  }) async {
    int iSuccess = 0;
    await prodRef.doc(sUIDDoc).set(data).then((value) {
      iSuccess = 1;
    });
    return iSuccess;
  }
}
