
import 'package:siwat_mushroom/Constant/field_master.dart';

class ModelCostMaterial {
  int index;
  String sUID = '';
  String sUserUID = '';
  String sMaterialName;
  String sAmount;
  String sUnitAmount;
  String sMaterialPrice;
  String sSaveDateTime;
  String sSaveTimeStamp;
  bool isItemSelected;

  ModelCostMaterial(
      {required this.index,
      required this.sUID,
      required this.sUserUID,
      required this.sMaterialName,
      required this.sAmount,
      required this.sUnitAmount,
      required this.sMaterialPrice,
      required this.sSaveDateTime,
      required this.sSaveTimeStamp,
      required this.isItemSelected,
      });

  formFireStore({
    required Map<String, dynamic> json,
  }) {
    sUID = json[FieldMaster.sProdUID] ?? '';
    sUserUID = json[FieldMaster.sProdUserUID] ?? '';
    sMaterialName = json[FieldMaster.sMaterialName] ?? '';
    sAmount = json[FieldMaster.sMaterialAmount] ?? '';
    sUnitAmount = json[FieldMaster.sMaterialUnitAmount] ?? '';
    sMaterialPrice = json[FieldMaster.sMaterialPrice] ?? '';
    sSaveDateTime = json[FieldMaster.sMaterialDateSave] ?? '';
    sSaveTimeStamp = json[FieldMaster.sMaterialSaveTime] ?? '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[FieldMaster.sMaterialUID] = sUID;
    map[FieldMaster.sMaterialUserUID] = sUserUID;
    map[FieldMaster.sMaterialName] = sMaterialName;
    map[FieldMaster.sMaterialAmount] = sAmount;
    map[FieldMaster.sMaterialUnitAmount] = sUnitAmount;
    map[FieldMaster.sMaterialPrice] = sMaterialPrice;
    map[FieldMaster.sMaterialDateSave] = sSaveDateTime;
    map[FieldMaster.sMaterialSaveTime] = sSaveTimeStamp;
    return map;
  }

}
