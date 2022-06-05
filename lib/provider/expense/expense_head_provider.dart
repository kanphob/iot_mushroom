
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_mushroom/Constant/drop_down_data.dart';
import 'package:iot_mushroom/Model/model_expense.dart';
import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Utils/std_widget.dart';
class ExpenseHeadProvider with ChangeNotifier{
  final expenseCollection = FirebaseFirestore.instance.collection('expense');

  TextEditingController txtSearch = TextEditingController();

  STDWidget widget = STDWidget();

  Future<List<ModelExpense>> getAllData({
    required String sUIDUser,
  }) async {
    List<ModelExpense> list = [];
    await expenseCollection
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
        ModelExpense md = ModelExpense();
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
    await expenseCollection.doc(sUIDDoc).set(data).then((value) {
      iSuccess = 1;
    });
    return iSuccess;
  }


  Map<String, String> valFormType(ModelExpense md) {
    Map<String, String> data = {};
    List<DropDownData> listType = DropDownData.getDataExpense();
    int iType = 0;
    data[FieldMaster.sExpenseType] = listType[iType].sLabel;
    return data;
  }

}