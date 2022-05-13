import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_condition.dart';
import 'package:siwat_mushroom/Model/model_cost_material.dart';
import 'package:siwat_mushroom/Utils/floating_calculator.dart';
import 'package:siwat_mushroom/Screen/table_statistic_condition.dart';
import 'package:siwat_mushroom/Screen/table_statistic_cost.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CostCalculateCreate extends StatefulWidget {
  const CostCalculateCreate({Key? key}) : super(key: key);

  @override
  _CostCalculateCreateState createState() => _CostCalculateCreateState();
}

class _CostCalculateCreateState extends State<CostCalculateCreate> {
  final dateFormatUser = DateFormat('dd/MM/yyyy');
  final dateFormatSystem = DateFormat('yyyy/MM/dd');
  String sCurrentDateTime = "";
  int iCurrentRoundSave = 1;
  int iTemperatureAmount = 0;
  int iHumidityAmount = 0;
  int iLightAmount = 0;
  int iCarbonDioxide = 0;
  List<ModelCostMaterial> listCostMaterial = [];
  List<ModelCostMaterial> listCostMaterialTemp = [];
  String sCurrentMaterialValue = 'วัสดุทางตรง';
  String sBluetooth = 'Bluetooth';
  String sEthernet = 'Ethernet';
  String sUSB = 'USB';
  bool printerEnable = false;
  TextEditingController materialTypeController = TextEditingController();
  List<DropdownMenuItem<String>> typeDropdownList = [];
  List<String> typeListForm = ['วัสดุทางตรง', 'วัสดุทางอ้อม'];
  TextEditingController typeController = TextEditingController();
  String sAddType = "";
  bool bTypeInput = false;
  final FocusNode focusType = FocusNode();
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateStartController = TextEditingController();
  DateTime dtStartDate = DateTime.now().toUtc();
  bool bDeleteMode = false;
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    sCurrentDateTime = dateFormatUser.format(DateTime.now());
    dateStartController.text = sCurrentDateTime;
    listCostMaterial = [];
    listCostMaterialTemp = [];
    addDropdownSelector();
    setState(() {});
  }

  addDropdownSelector() {
    typeDropdownList = [];
    typeDropdownList.add(
      DropdownMenuItem<String>(
        value: "",
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.green.shade50,
          ),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
              SizedBox(
                width: 10,
              ),
              Text("สร้างประเภทต้นทุนใหม่",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.green)),
            ],
          ),
        ),
      ),
    );

    for (int i = 0; i < typeListForm.length; i++) {
      typeDropdownList.add(
        DropdownMenuItem<String>(
            value: typeListForm[i],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 20),
                    Text(typeListForm[i],
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(
                  height: 1,
                )
              ],
            )),
      );
    }
    setState(() {});
  }

  resetData() {
    listCostMaterialTemp = [];
    listCostMaterialTemp.addAll(listCostMaterial);
    listCostMaterial = [];
    for(int i = 0; i < listCostMaterialTemp.length;i++){
      listCostMaterial.add(listCostMaterialTemp[i]);
      listCostMaterial[i].index = i;
      listCostMaterial[i].isItemSelected = false;
    }

    if(listCostMaterial.length > 0){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title:  GestureDetector(
          onTap: (){
            print(listCostMaterial.length);
            print(listCostMaterialTemp.length);
            setState(() {

            });
          },
          child: const Text("ระบบการคำนวณต้นทุน"),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                color: Colors.green.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(flex: 2, child: Container()),
                                    Expanded(
                                        flex: 5,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "วันที่ : ",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Expanded(
                                              child: DateTimeField(
                                                readOnly: true,
                                                resetIcon: null,
                                                textAlign: TextAlign.center,
                                                controller: dateStartController,
                                                format: dateFormatUser,
                                                style: TextStyle(
                                                    color:
                                                        Colors.blue.shade800),
                                                onShowPicker: (context,
                                                    currentValue) async {
                                                  dtStartDate = DateTime(
                                                      dtStartDate.year,
                                                      dtStartDate.month,
                                                      dtStartDate.day,
                                                      dtStartDate.hour,
                                                      dtStartDate.minute,
                                                      dtStartDate.second);
                                                  final date = await DatePicker
                                                      .showDatePicker(
                                                    context,
                                                    //theme: ThemeData(primarySwatch: Colors.purple),
                                                    currentTime: DateTime(
                                                        dtStartDate.year,
                                                        dtStartDate.month,
                                                        dtStartDate.day),
                                                    locale: LocaleType.th,
                                                    minTime: DateTime(
                                                        DateTime.now().year -
                                                            5),
                                                    maxTime: DateTime(
                                                        DateTime.now().year +
                                                            5),
                                                  );
                                                  if (date != null) {
                                                    dtStartDate = date;
                                                    // String sThaiMonth = dtStartDate.day.toString() +
                                                    //     ' ' + getMonthName(dtStartDate.month) + ' ' +
                                                    //     dtStartDate.year.toString();
                                                    dateStartController =
                                                        TextEditingController(
                                                            text: dateFormatUser
                                                                .format(
                                                                    dtStartDate));

                                                    return DateTime(
                                                      date.year,
                                                      date.month,
                                                      date.day,
                                                    );
                                                  } else {
                                                    // String sThaiMonth = dtStartDate.day.toString() +
                                                    //     ' ' + getMonthName(dtStartDate.month) + ' ' +
                                                    dtStartDate.year.toString();
                                                    dateStartController =
                                                        TextEditingController(
                                                            text: dateFormatUser
                                                                .format(
                                                                    dtStartDate));
//                              return DateTime(
//                                  dtStartDate.year,
//                                  dtStartDate.month,
//                                  dtStartDate.day,
//                                  dtStartDate.hour,
//                                  dtStartDate.minute);
                                                    return null;
                                                  }
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  suffixIcon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Colors.grey,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(flex: 2, child: Container()),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "รอบที่ : " +
                                            iCurrentRoundSave.toString() +
                                            " / " +
                                            (DateTime.now().year + 543)
                                                .toString(),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                buildDropDownMaterialType(),
                              ],
                            )))
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                flex: 10,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Colors.green.shade300,
                      )),
                  elevation: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                              ),
                            ),
                            height: 50,
                            child: ListView(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (typeController.text.isNotEmpty) {
                                      listCostMaterial.add(ModelCostMaterial(
                                          index: listCostMaterial.length,
                                          sMaterialName: sCurrentMaterialValue,
                                          sAmount: "0",
                                          sUnitAmount: "",
                                          sCostValue: "0",
                                          sDateTime: '',
                                          isItemSelected: false));
                                      listCostMaterialTemp = [];
                                      listCostMaterialTemp.addAll(listCostMaterial);
                                      if (listCostMaterial.isNotEmpty) {
                                        _formKey.currentState!.validate();
                                        setState(() {});
                                      }
                                    } else {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "เพิ่มรายการต้นทุน",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1.3,
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Scrollbar(child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: listCostMaterial.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index == 0
                                        ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding:
                                            const EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: const [
                                                Text("ลำดับ"),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(
                                                  10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: const [
                                                  Expanded(
                                                    child: Text(
                                                      "รายการ",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      maxLines: 2,
                                                      textAlign: TextAlign
                                                          .center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(
                                                    10),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: const [
                                                            Text("จำนวน"),
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(
                                                  10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: const [
                                                          Text("ราคา"),
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Container(),
                                    buildItemCondition(
                                        listCostMaterial[index], index),
                                  ],
                                );
                              }))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.all(5),
                onPressed: () async {
                  if (bDeleteMode) {
                    await showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("ต้องการลบรายการหรือไม่?"),
                          actions: [
                            FlatButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                              label: const Text("ปิด"),
                            ),
                            FlatButton.icon(
                              onPressed: () async{
                                for (int i = 0; i < listCostMaterial.length; i++) {
                                  if (listCostMaterial[i].isItemSelected) {
                                    listCostMaterial.removeAt(i);
                                  }
                                }
                                await resetData();
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.delete,color: Colors.red,),
                              label: const Text("ลบ",style: TextStyle(color: Colors.red),),
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {

                    });
                  }
                },
                child: const Text('ลบรายการ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                disabledColor: bDeleteMode ? Colors.red : Colors.grey,
                color: bDeleteMode ? Colors.red : Colors.grey,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: CupertinoButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                String sDateTime = dateFormatSystem.format(dtStartDate);
                for (int i = 0; i < listCostMaterial.length; i++) {
                  listCostMaterial[i].sDateTime = sDateTime;
                }
                Globals.listCostMaterial.addAll(listCostMaterial);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TableStatisticCost()));
              },
              child: const Text('บันทึก',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              disabledColor: Colors.green,
              color: Colors.green,
            )),
          ],
        ),
      ),
    ));
  }

  buildDropDownMaterialCostType() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          bTypeInput
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "องค์ประกอบต้นทุนการผลิต : ",
                                labelStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green[700],
                                ),
                              ),
                              focusNode: focusType,
                              controller: typeController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'กรุณาระบุประเภท';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.green[700],
                                  ),
                                  onPressed: () {
                                    bTypeInput = false;
                                    setState(() {});
                                  })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : AbsorbPointer(
                  child: TextFormField(
                    controller: typeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "ประเภท : ",
                      labelStyle:
                          TextStyle(fontSize: 16.0, color: Colors.green[700]),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณาระบุประเภท';
                      }
                      return null;
                    },
                  ),
                ),
          bTypeInput == false
              ? DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.green,
                      ),
                      elevation: 5,
                      items: typeDropdownList,
                      dropdownColor: Colors.grey.shade200,
                      onChanged: (value) async {
                        setState(() {
                          sCurrentMaterialValue = value!;
                          typeController.text =
                              sCurrentMaterialValue.toString();
                        });
                        if (sCurrentMaterialValue == "") {
//                    _typeValue = "";
//                    bTypeInput = true;
//                    type_controller.text = "";
//                    FocusScope.of(context).requestFocus(focusType);
                          sAddType = await showDialog(
                              context: context,
                              builder: (_) {
                                return DialogAddType(
                                  listType: typeListForm,
                                );
                              });
                          typeListForm.add(sAddType);
                          typeController.text = sAddType;
                          await addDropdownSelector();
                          setState(() {});
                        }
                      },
                      isExpanded: true,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  buildDropDownMaterialType() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          bTypeInput
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "ประเภท : ",
                                labelStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green[700],
                                ),
                              ),
                              focusNode: focusType,
                              controller: typeController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'กรุณาระบุประเภท';
                                }
                                return null;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.green[700],
                                  ),
                                  onPressed: () {
                                    bTypeInput = false;
                                    setState(() {});
                                  })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : AbsorbPointer(
                  child: TextFormField(
                    controller: typeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "ประเภท : ",
                      labelStyle:
                          TextStyle(fontSize: 16.0, color: Colors.green[700]),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'กรุณาระบุประเภท';
                      }
                      return null;
                    },
                  ),
                ),
          bTypeInput == false
              ? DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.green,
                      ),
                      elevation: 5,
                      items: typeDropdownList,
                      dropdownColor: Colors.grey.shade200,
                      onChanged: (value) async {
                        setState(() {
                          sCurrentMaterialValue = value!;
                          typeController.text =
                              sCurrentMaterialValue.toString();
                        });
                        if (sCurrentMaterialValue == "") {
//                    _typeValue = "";
//                    bTypeInput = true;
//                    type_controller.text = "";
//                    FocusScope.of(context).requestFocus(focusType);
                          sAddType = await showDialog(
                              context: context,
                              builder: (_) {
                                return DialogAddType(
                                  listType: typeListForm,
                                );
                              });
                          typeListForm.add(sAddType);
                          typeController.text = sAddType;
                          await addDropdownSelector();
                          setState(() {});
                        }
                      },
                      isExpanded: true,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  buildItemCondition(ModelCostMaterial mdCostMaterial, int index) {
    return GestureDetector(
      onTap: () {
        bDeleteMode = false;
        listCostMaterial[index].isItemSelected =
            !listCostMaterial[index].isItemSelected;
        for (int i = 0; i < listCostMaterial.length; i++) {
          if (listCostMaterial[i].isItemSelected) {
            bDeleteMode = true;
          }
        }
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: mdCostMaterial.isItemSelected
                    ? Colors.blue.shade500
                    : Colors.grey.shade200,
                width: 1.5),
            borderRadius: BorderRadius.circular(5)),
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(0),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((mdCostMaterial.index + 1).toString()),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                mdCostMaterial.sMaterialName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(mdCostMaterial.sAmount),
                                Text(mdCostMaterial.sUnitAmount),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      String sAnswer = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return FloatCalculator(
                              valueInit:
                                  mdCostMaterial.sAmount.replaceAll(',', ''),
                            );
                          });

                      if (sAnswer != "") {
                        listCostMaterial[index].sAmount = sAnswer;
                        setState(() {});
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(mdCostMaterial.sCostValue),
                                Text(mdCostMaterial.sUnitAmount),
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      String sAnswer = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return FloatCalculator(
                              valueInit:
                                  mdCostMaterial.sCostValue.replaceAll(',', ''),
                            );
                          });

                      if (sAnswer != "") {
                        listCostMaterial[index].sCostValue = sAnswer;
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DialogAddType extends StatefulWidget {
  DialogAddType({Key? key, required this.listType}) : super(key: key);

  List<String> listType = [];

  @override
  _DialogAddTypeState createState() => _DialogAddTypeState();
}

class _DialogAddTypeState extends State<DialogAddType> {
  final _formKey = GlobalKey<FormState>();
  String sGID = "";
  String sLastDoc = "";
  List<String> groupListForm = [];
  List<TextEditingController> listTextField = [];
  TextEditingController groupNameFormController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  FocusNode focusType = FocusNode();

  String sFromTextField = "";
  bool bTypeAllow = false;
  String sValidate = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: <Widget>[
          Text(
            "เพิ่มประเภทวัตถุดิบ",
            style: TextStyle(
                color: Colors.green.shade300, fontWeight: FontWeight.bold),
          ),
          const Divider(
            height: 10,
          )
        ],
      ),
      content: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "ประเภท : ",
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.green.shade300,
                          ),
                        ),
                        focusNode: focusType,
                        controller: typeController,
                        validator: (value) => sValidate,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
//                    groupNameNew_controller.clear();
              },
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              )),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: FlatButton.icon(
              onPressed: () {
                _checkTypeIfExist(context);
              },
              icon: Icon(
                Icons.add,
                color: Colors.green.shade300,
              ),
              label: Text(
                'เพิ่ม',
                style: TextStyle(
                  color: Colors.green.shade300,
                ),
              )),
        ),
      ],
    );
  }

  _checkTypeIfExist(BuildContext context) async {
    bool isMatch = false;
    if (typeController.text.isEmpty) {
      bTypeAllow = false;
      sValidate = "กรุณาระบุประเภท";
      _formKey.currentState!.validate();
      setState(() {
        //
      });
    } else {
      String sTypeList = "";
      sFromTextField = typeController.text;
      //   // dbHomeType dbType = new dbHomeType();
      //   List<Map> lmType = await dbType.getTable();
      //   for (int i = 0; i < lmType.length; i++) {
      //     Map map = lmType[i];
      //     sTypeList = map[field.HOME_ACCOUNT_TYPE_APPROVED_BY_SERVER];
      //     if(sFromTextField == sTypeList){
      //       isMatch = true;
      //     }
      //   }
      //   if (isMatch) {
      //     bTypeAllow = false;
      //     sValidate = "ขออภัย..มีประเภทนี้อยู่ในระบบแล้ว";
      //     _formKey.currentState!.validate();
      //     setState(() {
      //
      //     });
      //   }else{
      //     sValidate = "";
      //     if(_formKey.currentState!.validate()){
      //       await _saveType();
      Navigator.pop(context, sFromTextField);
      //       setState(() {
      //
      //       });
      //     }
    }
  }

  // _saveType() async{
  // int iRet = 0;
  // String sTypeApproved = sFromTextField;
  // String sTypeCategory = sFromTextField;
  // String sDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  // ModelSelectType modelSelectType = new ModelSelectType(sDateTime, sDateTime, sTypeApproved, c0.YES, null);
  // MethodChannel methodChannel = const MethodChannel('home_account_chanel');
  // dbSelectType dbSelect = dbSelectType();
  // modelSelectType.setDocDate = sDateTime;
  // String sHeadGID = await methodChannel.invokeMethod('getGID', <String, dynamic>{
  //   tally.REF_TYPE: tally.TYPE_XSACT,
  // });
  // modelSelectType.setID = sHeadGID;
  // modelSelectType.setDocDate = sDateTime;
  // Map mdType = modelSelectType.toMap();
  // iRet = await dbSelect.insertData(sTypeApproved, mdType);
  // dbHomeType dbType = new dbHomeType();
  // ModelType modelType = ModelType(sDateTime,sFromTextField, sTypeApproved, sTypeCategory,"1", sGID);
  // Map mTypeData = modelType.toMap();
  // iRet = await dbType.insertData(sLastDoc, mTypeData);
  // }
  //   }

}
