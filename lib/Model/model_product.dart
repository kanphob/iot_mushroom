import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Constant/globals.dart';

class ModelProduct {
  String sUID = '';
  String sUserUID = '';
  String sTemperature = ''; // อุณหภูมิ
  String sMoisture = ''; // ความชื้น
  String sLight = ''; // แสงสว่าง
  String sCO2 = ''; // แสงสว่าง
  int iNumFlower = 0; // จํานวนดอกที่ผลิตได้
  int iQuantityProduced = 0; // ปริมาณที่ผลิตได้ (KG)
  String sDateSave = ''; // วันที่บันทึก
  String sSaveTimeStamp = ''; // เวลาที่กด Save

  formFireStore({
    required Map<String, dynamic> json,
  }) {
    sUID = json[FieldMaster.sProdUID] ?? '';
    sUserUID = json[FieldMaster.sUserUID] ?? '';
    sTemperature = json[FieldMaster.sProdTem] ?? '';
    sMoisture = json[FieldMaster.sProdMoisture] ?? '';
    sLight = json[FieldMaster.sProdLight] ?? '';
    sCO2 = json[FieldMaster.sProdCO2] ?? '';
    iNumFlower = json[FieldMaster.sProdNumFlower] ?? 0;
    iQuantityProduced = json[FieldMaster.sProdQuantityProduced] ?? 0;
    sDateSave = json[FieldMaster.sDateSave] ?? '';
    String sSaveTime = json[FieldMaster.sSaveTimeStamp] ?? '';
    DateTime dtSave = DateTime.parse(sSaveTime);
    sSaveTimeStamp = Globals.dateFormatTime.format(dtSave);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[FieldMaster.sProdUID] = sUID;
    map[FieldMaster.sUserUID] = sUserUID;
    map[FieldMaster.sProdTem] = sTemperature;
    map[FieldMaster.sProdMoisture] = sMoisture;
    map[FieldMaster.sProdLight] = sLight;
    map[FieldMaster.sProdCO2] = sCO2;
    map[FieldMaster.sProdNumFlower] = iNumFlower;
    map[FieldMaster.sProdQuantityProduced] = iQuantityProduced;
    map[FieldMaster.sDateSave] = sDateSave;
    map[FieldMaster.sSaveTimeStamp] = sSaveTimeStamp;
    return map;
  }
}
