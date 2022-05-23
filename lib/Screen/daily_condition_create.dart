import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siwat_mushroom/Constant/globals.dart';
import 'package:siwat_mushroom/Model/model_condition.dart';
import 'package:siwat_mushroom/Utils/floating_calculator.dart';
import 'package:siwat_mushroom/Screen/table_statistic_condition.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DailyConditionCreate extends StatefulWidget {
  const DailyConditionCreate({Key? key}) : super(key: key);

  @override
  _DailyConditionCreateState createState() => _DailyConditionCreateState();
}

class _DailyConditionCreateState extends State<DailyConditionCreate> {
  final dateFormatUser = DateFormat('dd/MM/yyyy');
  String sCurrentDateTime = "";
  int iCurrentRoundSave = 1;
  List<ModelCondition> listCondition = [];
  int iTemperatureAmount = 0;
  int iHumidityAmount = 0;
  int iLightAmount = 0;
  int iCarbonDioxide = 0;
  TextEditingController dateStartController = TextEditingController();
  DateTime dtStartDate = DateTime.now().toUtc();

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    sCurrentDateTime = dateFormatUser.format(DateTime.now());
    dateStartController.text = sCurrentDateTime;
    listCondition.clear();
    iTemperatureAmount = 0;
    iHumidityAmount = 0;
    iLightAmount = 0;
    iCarbonDioxide = 0;
    listCondition = [
      ModelCondition(
          sIconPath: "assets/images/temperature.png",
          sConditionName: "อุณหภูมิ",
          sAmount: iTemperatureAmount.toString(),
          sUnitAmount: "C",
          index: 0,
          sDateTime: sCurrentDateTime
      ),
      ModelCondition(
          sIconPath: "assets/images/rainfall.png",
          sConditionName: "ความชื้น",
          sAmount: iHumidityAmount.toString(),
          sUnitAmount: "%",
          index: 1,
          sDateTime: sCurrentDateTime),
      ModelCondition(
          sIconPath: "assets/images/sunny.png",
          sConditionName: "แสงสว่าง",
          sAmount: iLightAmount.toString(),
          sUnitAmount: "Lm",
          index: 2,
          sDateTime: sCurrentDateTime),
      ModelCondition(
          sIconPath: "assets/images/co2.png",
          sConditionName: "Co2",
          sAmount: iCarbonDioxide.toString(),
          sUnitAmount: "",
          index: 3,
          sDateTime: sCurrentDateTime),
    ];
    setState(() {});
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
        title: const Text("ระบบบันทึกข้อมูลรายวัน"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
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
                              )
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
                                GestureDetector(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "บันทึกข้อมูลปัจจัย",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                                  onTap: (){

                                  },
                                ),
                              ],
                            )),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: listCondition.length,
                            itemBuilder: (context, index) {
                              return buildItemCondition(
                                  listCondition[index], index);
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.all(5),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ยกเลิก',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                disabledColor: Colors.red,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: CupertinoButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                Globals.listCondition.add(listCondition);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TableStatisticCondition()));
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

  buildItemCondition(ModelCondition mdCondition, int index) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green.shade100),
          borderRadius: BorderRadius.circular(5)),
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
          title: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          Image.asset(mdCondition.sIconPath,
                              height: 50,
                              width: 50,
                              filterQuality: FilterQuality.medium,
                              fit: BoxFit.cover),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(mdCondition.sConditionName),
                        ],
                      ),
                    )),
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
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 1,
                            height: 50,
                          ),
                          Expanded(
                              child:
                              mdCondition.sAmount.length > 4?Column(children: [
                                Text(mdCondition.sAmount),
                                Text(mdCondition.sUnitAmount),
                              ],):Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(mdCondition.sAmount),
                              const SizedBox(
                                width: 10,
                              ),
                            Text(mdCondition.sUnitAmount),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    String sAnswer = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return FloatCalculator(
                            valueInit: mdCondition.sAmount.replaceAll(',', ''),
                          );
                        });

                    if (sAnswer != "") {
                      switch (index) {
                        case 0: iTemperatureAmount = int.parse(sAnswer);
                        break;
                        case 1: iHumidityAmount = int.parse(sAnswer);
                        break;
                        case 2: iLightAmount = int.parse(sAnswer);
                        break;
                        case 3: iCarbonDioxide = int.parse(sAnswer);
                      }
                      listCondition[index].sAmount = sAnswer;
                      setState(() {});
                    }

                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        checkAddRemoveAmount(index,
                            isAddAmount: true, isLongPressed: false);
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.green,
                        size: 35,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Listener(
                      onPointerDown: (details) {
                        _buttonPressed = true;
                        checkAddRemoveAmount(index,
                            isAddAmount: false, isLongPressed: false);
                      },
                      onPointerUp: (details) {
                        _buttonPressed = false;
                      },
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _buttonPressed = false;
  bool _loopActive = false;
  bool isStopped = false;
  late Timer timer;

  checkAddRemoveAmount(int index,
      {bool isAddAmount = true, bool isLongPressed = false}) async {
    isStopped = false;
    switch (index) {
      case 0:
        if (isAddAmount) {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iTemperatureAmount++;
              listCondition[index].sAmount = iTemperatureAmount.toString();
            });
            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        } else {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iTemperatureAmount--;
              listCondition[index].sAmount = iTemperatureAmount.toString();
            });

            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        }

        break;
      case 1:
        if (isAddAmount) {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iHumidityAmount++;
              listCondition[index].sAmount = iHumidityAmount.toString();
            });
            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        } else {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iHumidityAmount--;
              listCondition[index].sAmount = iHumidityAmount.toString();
            });

            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        }
        break;
      case 2:
        if (isAddAmount) {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iLightAmount++;
              listCondition[index].sAmount = iLightAmount.toString();
            });
            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        } else {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iLightAmount--;
              listCondition[index].sAmount = iLightAmount.toString();
            });

            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        }
        break;
      case 3:
        if (isAddAmount) {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iCarbonDioxide++;
              listCondition[index].sAmount = iCarbonDioxide.toString();
            });
            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        } else {
          if (_loopActive) return;
          _loopActive = true;
          while (_buttonPressed) {
            setState(() {
              iCarbonDioxide--;
              listCondition[index].sAmount = iCarbonDioxide.toString();
            });

            await Future.delayed(const Duration(milliseconds: 200));
          }
          _loopActive = false;
        }
        break;
    }
  }
}
