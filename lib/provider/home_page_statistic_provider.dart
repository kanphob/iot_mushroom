import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:iot_mushroom/Constant/field_master.dart';
import 'package:iot_mushroom/Model/model_expense.dart';
import 'package:iot_mushroom/Model/model_income.dart';
import 'package:iot_mushroom/Screen/home_page.dart';
import 'package:iot_mushroom/Utils/utils.dart';
import 'package:iot_mushroom/provider/home_page_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePageStatisticProvider extends HomePageProvider {
  HomePageStatisticProvider({required super.context}) {
    setDateYearSelect();
    setDataStatistic();
  }
  final incomeCollection = FirebaseFirestore.instance.collection('income');
  final expenseCollection = FirebaseFirestore.instance.collection('expense');

  final dateFormat = DateFormat('dd-MM-yyyy');
  final yyyyMMddFormat = DateFormat('yyyy-MM-dd');
  final yyyyFormat = DateFormat('yyyy');
  final mmFormat = DateFormat('MM');

  DateTime dateSelect = DateTime.now();

  bool bDownloading = false;
  bool bBarChart = false;

  String dropYear = "";
  String sDateFilter = "";
  String sYearFilter = "";
  String sMonthFilter = "";

  double dTotal = 0;
  double dSumIn = 0;
  double dSumEx = 0;
  double dSumAll = 0;

  int waitResult = 0;

  Map<String, double> dataMap = {};

  List<String> listYear = [];
  List<Color> defaultColorList = [
    const Color(0x9946bbc4),
    const Color(0xFFE57373),
    const Color(0x99b5d7e8)
  ];

  List<charts.Series<OrdinalSales, String>> createSampleData() {
    final data = [
      OrdinalSales('รายได้', dSumIn.round()),
      OrdinalSales('ค่าใช้จ่าย', dSumEx.round()),
    ];

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Charts',
        colorFn: (OrdinalSales data, _) {
          switch (data.sIncomeExpense) {
            case "รายได้":
              return charts.ColorUtil.fromDartColor(const Color(0x9946bbc4));
            case "ค่าใช้จ่าย":
                return charts.ColorUtil.fromDartColor(const Color(0xFFE57373));
            default:
              return charts.ColorUtil.fromDartColor(const Color(0x99b5d7e8));
          }
        },
        domainFn: (OrdinalSales sales, _) => sales.sIncomeExpense,
        measureFn: (OrdinalSales sales, _) => sales.iAmount,
        data: data,
      )
    ];
  }

  setDateYearSelect() {
    listYear.clear();
    dropYear = DateTime.now().year.toString();
    for (int i = 1990; i < 2100; i++) {
      listYear.add(i.toString());
    }
    sDateFilter = yyyyMMddFormat.format(dateSelect);
    sMonthFilter = mmFormat.format(dateSelect);
    sYearFilter = yyyyFormat.format(dateSelect);
  }

  setDataStatistic() async {
    dataMap.clear();
    waitResult += await getData(0);

    dataMap.putIfAbsent("รายได้ ", () => dSumIn);
    dataMap.putIfAbsent("ค่าใช้จ่าย ", () => dSumEx);
    dTotal = dSumIn + dSumEx;
    notifyListeners();
  }

  onChangeDropdown(String sNewValue) async {
    dropYear = sNewValue;
    sYearFilter = dropYear;
    dSumIn = 0;
    dSumEx = 0;
    dSumAll = 0;
    await setDataStatistic();
  }

  onChangeChartType({bool isBarChart = false}) {
    if (isBarChart) {
      bBarChart = true;
    } else {
      bBarChart = false;
    }
    notifyListeners();
  }

  Future<int> getData(int index) async {
    int iResultDone = 0;

    if (!bDownloading) {
      bDownloading = true;
      notifyListeners();
      List<ModelIncome> listMdIncome =
          await getAllDataIncome(sUIDUser: sUserUid);
      List<ModelExpense> listMdExpense =
          await getAllDataExpense(sUIDUser: sUserUid);
      if (listMdIncome.isNotEmpty) {
        for (int i = 0; i < listMdIncome.length; i++) {
          if (listMdIncome[i].sTotalAmt.isNotEmpty &&
              listMdIncome[i].sSaveDateTime.contains(sYearFilter)) {
            dSumIn += double.parse(listMdIncome[i].sTotalAmt);
          }
        }
      }
      if (listMdExpense.isNotEmpty) {
        for (int i = 0; i < listMdExpense.length; i++) {
          if (listMdExpense[i].sTotalAmt.isNotEmpty &&
              listMdIncome[i].sSaveDateTime.contains(sYearFilter)) {
            dSumEx += double.parse(listMdExpense[i].sTotalAmt);
          }
        }
      }
      dSumAll = dSumIn - dSumEx;
      if (dSumAll > 0) {
        iResultDone = 1;
      }
      bDownloading = false;
      notifyListeners();
    }
    return iResultDone;
  }

  setSearchParameters(String name) {
    List<String> searchOptions = [];
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      searchOptions.add(temp);
    }
    return searchOptions;
  }

  Future<List<ModelIncome>> getAllDataIncome({
    required String sUIDUser,
  }) async {
    List<ModelIncome> list = [];

    await incomeCollection
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
        ModelIncome md = ModelIncome();
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

  Future<List<ModelExpense>> getAllDataExpense({
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
}
