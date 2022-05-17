//17/05/2565 ByBird
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siwat_mushroom/Constant/field_master.dart';
import 'package:siwat_mushroom/Model/model_product.dart';

class ProductHeadProvider with ChangeNotifier {
  final prodRef = FirebaseFirestore.instance.collection('product');

  TextEditingController txtDateStart = TextEditingController();
  TextEditingController txtDateEnd = TextEditingController();

  Future<void> getAllData({
    required String sUIDUser,
  }) async {
    List<ModelProduct> list = [];
    await prodRef
        .where(FieldMaster.sProdUserUID, isEqualTo: sUIDUser)
        .orderBy(
          FieldMaster.sProdDateSave,
        )
        .get()
        .then((value) {
      for (var m in value.docChanges) {
        ModelProduct md = ModelProduct();
        md.formFireStore(json: m.doc.data()!);
        list.add(md);
      }
    }).catchError((error) {
      print(error.toString());
    }).timeout(
      const Duration(minutes: 1),
    );
  }
}
