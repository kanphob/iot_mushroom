import 'package:siwat_mushroom/Constant/field_master.dart';

class ModelProduct {
  String sUID = '';
  String sUserUID = '';
  String sTemperature = ''; // อุณหภูมิ
  String sMoisture = ''; // ความชื้น
  String sLight = ''; // แสงสว่าง
  int iNumFlower = 0; // จํานวนดอกที่ผลิตได้
  int iQuantityProduced = 0; // ปริมาณที่ผลิตได้ (KG)
  String sDateSave = ''; // วันที่บันทึก
  String sSaveTimeStamp = ''; // เวลาที่กด Save

  formFireStore({
    required Map<String, dynamic> json,
  }) {
    sUID = json[FieldMaster.sProdUID] as String;
    sUserUID = json[FieldMaster.sProdUserUID] as String;
    sTemperature = json[FieldMaster.sProdTem] as String;
    sMoisture = json[FieldMaster.sProdMoisture] as String;
    sLight = json[FieldMaster.sProdLight] as String;
    iNumFlower = json[FieldMaster.sProdNumFlower] as int;
    iQuantityProduced = json[FieldMaster.sProdQuantityProduced] as int;
    sDateSave = json[FieldMaster.sProdDateSave] as String;
    sSaveTimeStamp = json[FieldMaster.sProdSaveTimeStamp] as String;
  }
}
