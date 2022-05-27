import 'package:siwat_mushroom/Constant/field_master.dart';
import 'package:siwat_mushroom/Constant/globals.dart';

class ModelIncome {
  String sUID = '';
  String sUserUID = '';
  String sSaveDateTime = '';
  String sSaveTimeStamp = '';
  String sItem = '';
  String sTotalAmt = '0.00';
  double dTotalAmt = 0.00;
  String sIncomeType = '';

  formFireStore({
    required Map<String, dynamic> json,
  }) {
    sUID = json[FieldMaster.sIncomeUID] ?? '';
    sUserUID = json[FieldMaster.sUserUID] ?? '';
    sIncomeType = json[FieldMaster.sIncomeType] ?? '';
    sItem = json[FieldMaster.sIncomeItem] ?? '';
    sTotalAmt = json[FieldMaster.sIncomeAmt] ?? '';
    sSaveDateTime = json[FieldMaster.sDateSave] ?? '';
    String sSaveTime = json[FieldMaster.sSaveTimeStamp] ?? '';
    DateTime dtSave = DateTime.parse(sSaveTime);
    sSaveTimeStamp = Globals.dateFormatTime.format(dtSave);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[FieldMaster.sIncomeUID] = sUID;
    map[FieldMaster.sUserUID] = sUserUID;
    map[FieldMaster.sIncomeType] = sIncomeType;
    map[FieldMaster.sIncomeItem] = sItem;
    map[FieldMaster.sIncomeAmt] = sTotalAmt;
    map[FieldMaster.sDateSave] = sSaveDateTime;
    map[FieldMaster.sSaveTimeStamp] = sSaveTimeStamp;
    return map;
  }

}