
import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Constant/globals.dart';

class ModelCostMaterial {
  int index = 0;
  String sUID = '';
  String sUserUID = '';
  String sMaterialName = '';
  String sAmount = '';
  String sUnitAmount = '';
  String sMaterialPrice = '';
  String sSaveDateTime = '';
  String sSaveTimeStamp = '';
}

class ModelCostMat {
  String sUID = '';
  String sUserUID = '';
  String sSaveDateTime = '';
  String sSaveTimeStamp = '';
  String sTotalAmt = '0.00';
  double dTotalAmt = 0.00;
  String sItem = '';
  String sTypeCost = '';
  String sCost = '';

  formFireStore({
    required Map<String, dynamic> json,
  }) {
    sUID = json[FieldMaster.sMatUID] ?? '';
    sUserUID = json[FieldMaster.sUserUID] ?? '';
    sItem = json[FieldMaster.sMatItem] ?? '';
    sTypeCost = json[FieldMaster.sMatTypeCost] ?? '';
    sCost = json[FieldMaster.sMatCost] ?? '';
    sTotalAmt = json[FieldMaster.sMatAMT] ?? '';
    sSaveDateTime = json[FieldMaster.sDateSave] ?? '';
    String sSaveTime = json[FieldMaster.sSaveTimeStamp] ?? '';
    DateTime dtSave = DateTime.parse(sSaveTime);
    sSaveTimeStamp = Globals.dateFormatTime.format(dtSave);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[FieldMaster.sMatUID] = sUID;
    map[FieldMaster.sUserUID] = sUserUID;
    map[FieldMaster.sMatItem] = sItem;
    map[FieldMaster.sMatTypeCost] = sTypeCost;
    map[FieldMaster.sMatCost] = sCost;
    map[FieldMaster.sMatAMT] = sTotalAmt;
    map[FieldMaster.sDateSave] = sSaveDateTime;
    map[FieldMaster.sSaveTimeStamp] = sSaveTimeStamp;
    return map;
  }
}
