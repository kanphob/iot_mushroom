import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Constant/globals.dart';

class ModelExpense {
  String sUID = '';
  String sUserUID = '';
  String sSaveDateTime = '';
  String sSaveTimeStamp = '';
  String sItem = '';
  String sTotalAmt = '0.00';
  double dTotalAmt = 0.00;
  String sExpenseType = '';

  formFireStore({
    required Map<String, dynamic> json,
  }) {
    sUID = json[FieldMaster.sExpenseUID] ?? '';
    sUserUID = json[FieldMaster.sUserUID] ?? '';
    sExpenseType = json[FieldMaster.sExpenseType] ?? '';
    sItem = json[FieldMaster.sExpenseItem] ?? '';
    sTotalAmt = json[FieldMaster.sExpenseAmt] ?? '';
    sSaveDateTime = json[FieldMaster.sDateSave] ?? '';
    String sSaveTime = json[FieldMaster.sSaveTimeStamp] ?? '';
    DateTime dtSave = DateTime.parse(sSaveTime);
    sSaveTimeStamp = Globals.dateFormatTime.format(dtSave);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[FieldMaster.sExpenseUID] = sUID;
    map[FieldMaster.sUserUID] = sUserUID;
    map[FieldMaster.sExpenseType] = sExpenseType;
    map[FieldMaster.sExpenseItem] = sItem;
    map[FieldMaster.sExpenseAmt] = sTotalAmt;
    map[FieldMaster.sDateSave] = sSaveDateTime;
    map[FieldMaster.sSaveTimeStamp] = sSaveTimeStamp;
    return map;
  }

}